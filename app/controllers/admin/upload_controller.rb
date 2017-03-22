module Admin
  class UploadController < Admin::BaseController
    include UploadHelper
    require 'csv'

    def upload
    end

    def download
      # Retrieve the resource requested to upload e.g Users
      resource_name = params[:resource_choice]
      # Will store verified resource
      resource = nil

      # Verify that the resource with the corresponding name exists
      %w(courses uni_modules departments faculties).each do |verify_resource|
        if verify_resource.to_s == resource_name
          resource = verify_resource
        end
      end

      # Store the resource as a session variable
      session[:resource_name] = resource.to_s

      # Retrieves the attribute names depending on resource
      resource_header = resource.to_s.classify.constantize.attribute_names

      # Remove attributes that shouldn't appear on CSV
      to_remove = %w(id created_at updated_at)
      resource_header = resource_header - to_remove

      # Store resource header as session variable
      session[:resource_header] = resource_header

      # Add specific association attributes
      # Add additional header attribute for the departments of the faculty/courses
      if resource.to_s == 'faculties' || resource.to_s == 'courses'
        resource_header << 'departments'
      end

      if resource.to_s == 'uni_modules'
        # Add attribute for departments, prerequisite_modules and tags
        resource_header << 'prerequisite_modules'
        resource_header << 'career_tags'
        resource_header << 'interest_tags'
        resource_header << 'departments'
      end

      # Replace faculty_id attribute with faculty_name for departments
      if resource.to_s == 'departments'
        # Remove faculty_id attribute
        resource_header.delete('faculty_id')
        # Add faculty_name
        resource_header << 'faculty_name'
      end

      # Create a CSV file in the specified path
      file_name = "app/assets/#{resource.to_s}_upload.csv"
      CSV.open(file_name, 'wb') do |csv|
        # Add the attribute names as the header/first row
        csv << resource_header
      end

      # Send the file for download
      send_file file_name, type: 'text/csv', x_sendfile: true
    end

    def upload_csv
      # Retrieve csv file that was uploaded
      uploaded_csv = params[:csv_upload]

      # Keep rough counter of changes
      creations = 0
      updates = 0

      # Store/Write uploaded csv file to app/assets directory
      File.open(Rails.root.join('app', 'assets', 'uploaded.csv'), 'wb') do |file|
        file.write(uploaded_csv.read)
      end

      # Process CSV for reading
      csv_text = File.read('app/assets/uploaded.csv')
      parsed_csv = CSV.parse(csv_text, headers: true)
      uploaded_header = parsed_csv.headers

      if parsed_csv.length == 0
        # Validate if uploaded CSV is empty
        flash[:error] = 'Upload Failed: No records found. CSV is empty'

        # Validate uploaded file headers
      elsif uploaded_header != session[:resource_header]
        flash[:error] = 'Upload Failed: Please ensure the CSV header matches the template file'

      else # Validation checks passed, continue with upload
        # Create records each row of the uploaded csv file
        parsed_csv.each do |row|
          new_record = row.to_hash
          # When uploading departments, specify faculty name instead of id
          if session[:resource_name] == 'departments'
            # Lookup a faculty with matching name and retrieve it's ID
            # If no faculty with matching name found, don't create the department
            if Faculty.where(name: row.to_hash['faculty_name']).first.nil?
              flash[:error] = "No Faculty with name: #{row.to_hash['faculty_name']} found.
                              Department with name: #{row.to_hash['name']} has not been created"
            else
              new_record['faculty_id'] = Faculty.where(name: row.to_hash['faculty_name']).first.id
              # Remove the faculty name attribute from row hash
              new_record = new_record.except('faculty_name')
              # Check whether to update a department or create a new one
              if Department.find_by_name(new_record['name']).nil?
                Department.create(new_record).errors.full_messages.each { |message| flash[:error] = "Creation failed: #{message}" }
                creations += 1
              else
                Department.update(new_record)
                updates += 1
              end
            end

          elsif session[:resource_name] == 'faculties'
            # Faculties upload: Add departments attribute to create and/or link departments to the faculty
            faculty_entry = nil
            # Check that name is not blank
            if new_record['name'].nil?
              flash[:error] = 'Creation failed: Name cannot be left blank'
            else
              # Check whether to update a faculty or create a new one
              if Faculty.find_by_name(new_record['name']).nil?
                # Create a new faculty
                faculty_entry = Faculty.create(new_record.except('departments'))
                creations += 1
              else
                # Retrieve the existing faculty
                faculty_entry = Faculty.find_by_name(new_record['name'])
                updates += 1
              end
              # Clear the departments of this faculty before overriding/updating
              faculty_entry.departments= []
              # For every entered department
              parse_mult_association_string(new_record['departments']).each do |dept_name|
                # Look for a department with the name
                department_found = Department.find_by_name(dept_name)
                if department_found.nil?
                  # Create and link department with the this faculty
                  Department.create(name: dept_name, faculty_id: faculty_entry.id)
                else
                  # Link department with this faculty
                  department_found.update(faculty_id: faculty_entry.id)
                end
              end
            end

          elsif session[:resource_name] == 'courses'
            # Add departments attribute to create and/or link departments to this course
            # Lookup if Course already exists: Course is unique by name + year combo
            created_course = Course.find_by(name: new_record['name'], year: new_record['year'])
            # Track if Course failed to be created
            course_verification_failed = false
            if created_course.nil?
              # Store any verification errors + Create Course
              created_course_errors = Course.create!(new_record.except('departments')).errors.full_messages
              if created_course_errors.any?
                course_verification_failed = true
                # Flash errors
                created_course_errors.each { |message| flash[:error] = "Creation failed: #{message}" }
              else
                # Find created course
                created_course = Course.find_by(name: new_record['name'], year: new_record['year'])
                creations += 1
              end
            else
              # Update the existing Course
              created_course.update(new_record.except('departments'))
              updates += 1
            end
            unless course_verification_failed
              # Clear the departments this course belongs to before overriding/updating
              created_course.departments= []
              # For every entered department
              parse_mult_association_string(new_record['departments']).each do |dept_name|
                # Look for a department with the name
                department_found = Department.find_by_name(dept_name)
                unless department_found.nil?
                  # Add the found department to the departments the course belongs to
                  created_course.departments << department_found
                else flash[:error] = "Department with name: #{dept_name} does not exist and therefore has not
                                        been linked to Course: #{new_record['name']}, #{new_record['year']}"
                end
              end
            end

          elsif session[:resource_name] == 'uni_modules'
            # Add departments attribute to create and/or link departments to this module
            # Track if module failed to be created
            module_verification_failed = false
            # Lookup if Module already exists: Module is unique by Code
            created_module = UniModule.find_by_code(new_record['code'])

            if created_module.nil?
              UniModule.create(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags'))
                # Find created module
                created_module = UniModule.find_by_code(new_record['code'])
                creations += 1
                departments = new_record['departments'].split(';')
                required = new_record['prerequisite_modules'].split(';')
                career_tags = new_record['career_tags'].split(';')
                interest_tags = new_record['interest_tags'].split(',')

                created_module.departments.clear()
                if current_user.user_level == "department_admin_access"
                  user_dept = Department.find(current_user.department_id).name
                  if !(departments.include? user_dept)
                    # If user does not include their own department in the department list.
                    created_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
                    return
                  end
                end
                departments.each do |dept|
                  chosen_dept = Department.find_by_name(dept)
                  created_module.departments << chosen_dept
                end

                created_module.uni_modules.clear()
                if required.include? created_module.name
                  created_module.errors[:base] << "A module cannot be a prerequisite of itself."
                  return
                end
                required.each do |mod|
                  chosen_mod = UniModule.find_by_name(mod)
                  created_module.uni_modules << chosen_mod
                end

                created_module.tags.clear()

                career_tags.each do |tag|
                  chosen_tag = Tag.find_by_name(tag)
                  # Add the career tag association
                  if chosen_tag.present?
                    created_module.tags << chosen_tag
                  else
                    # If tag does not already exist then create a new tag
                    new_tag = Tag.new(name: tag, type: "CareerTag")
                    created_module.tags << new_tag
                  end
                end

                interest_tags.each do |tag|
                  chosen_tag = Tag.find_by_name(tag)
                   # Add the interest tag association
                  if chosen_tag.present?
                    created_module.tags << chosen_tag
                  else
                    # If tag does not already exist then create a new tag
                    new_tag = Tag.new(name: tag, type: "InterestTag")
                    created_module.tags << new_tag
                  end
                end

            else
              # Update the existing Module
              UniModule.update(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags'))
                # Find created module
                created_module = UniModule.find_by_code(new_record['code'])
                creations += 1
                departments = new_record['departments'].split(';')
                required = new_record['prerequisite_modules'].split(';')
                career_tags = new_record['career_tags'].split(';')
                interest_tags = new_record['interest_tags'].split(',')

                created_module.departments.clear()
                if current_user.user_level == "department_admin_access"
                  user_dept = Department.find(current_user.department_id).name
                  if !(departments.include? user_dept)
                    # If user does not include their own department in the department list.
                    created_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
                    return
                  end
                end
                departments.each do |dept|
                  chosen_dept = Department.find_by_name(dept)
                  created_module.departments << chosen_dept
                end

                created_module.uni_modules.clear()
                if required.include? created_module.name
                  created_module.errors[:base] << "A module cannot be a prerequisite of itself."
                  return
                end
                required.each do |mod|
                  chosen_mod = UniModule.find_by_name(mod)
                  created_module.uni_modules << chosen_mod
                end

                created_module.tags.clear()

                career_tags.each do |tag|
                  chosen_tag = Tag.find_by_name(tag)
                  # Add the career tag association
                  if chosen_tag.present?
                    created_module.tags << chosen_tag
                  else
                    # If tag does not already exist then create a new tag
                    new_tag = Tag.new(name: tag, type: "CareerTag")
                    created_module.tags << new_tag
                  end
                end

                interest_tags.each do |tag|
                  chosen_tag = Tag.find_by_name(tag)
                   # Add the interest tag association
                  if chosen_tag.present?
                    created_module.tags << chosen_tag
                  else
                    # If tag does not already exist then create a new tag
                    new_tag = Tag.new(name: tag, type: "InterestTag")
                    created_module.tags << new_tag
                  end
                end
              updates += 1
            end

          else
            # Will never reach here based on current front end restrictions
            # General creation
            session[:resource_name].to_s.classify.constantize.create!(new_record)
          end
        end
      end

      flash[:success] = "Upload complete: Processed #{creations} creations, #{updates} updates"
      redirect_to :back
    end

  end
end