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
              else
                Department.update(new_record)
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
              else
                # Retrieve the existing faculty
                faculty_entry = Faculty.find_by_name(new_record['name'])
              end
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
              end
            else
              # Update the existing Course
              created_course.update(new_record.except('departments'))
            end
            unless course_verification_failed
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
              created_module_errors = UniModule.create(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags')).errors.full_messages
              if created_module_errors.any?
                module_verification_failed = true
                # Flash errors
                created_module_errors.each { |message| flash[:error] = "Creation failed: #{message}" }
              else
                # Find created module
                created_module = UniModule.find_by_code(new_record['code'])
                # For every entered department
                parse_mult_association_string(new_record['departments']).each do |dept_name|
                  # Look for a department with the name
                  department_found = Department.find_by_name(dept_name)
                  unless department_found.nil?
                    # Add the found department to the departments the module belongs to
                    created_module.departments << department_found
                  end
                end

                # Add prerequisite modules
                parse_mult_association_string(new_record['prerequisite_modules']).each do |module_code|
                  # Lookup the module by unique code
                  module_found = UniModule.find_by_code(module_code)
                  # Link prereq to module unless prereq. module doesn't exist
                  unless module_found.nil?
                    # Add the found module to this modules prerequisites
                    created_module.uni_modules << module_found
                  end
                end

                unless new_record['career_tags'].nil?
                  # Add career_tags
                  parse_mult_association_string(new_record['career_tags']).each do |career_tag_name|
                    # Lookup if tag with same name exists already
                    career_tag_found = CareerTag.find_by(name: career_tag_name, type: 'CareerTag')
                    if career_tag_found.nil? && (not career_tag_name == '')
                      # Create new tag and add to this module
                      created_module.add_tag(CareerTag.create(name: career_tag_name, type: 'CareerTag'))
                    else
                      # Already exists, so add to this module
                      created_module.add_tag(career_tag_found)
                    end
                  end
                end

                unless new_record['interest_tags'].nil?
                  # Add interest_tags
                  parse_mult_association_string(new_record['interest_tags']).each do |interest_tag_name|
                    # Lookup if tag with same name exists already
                    interest_tag_found = InterestTag.find_by(name: interest_tag_name, type: 'InterestTag')
                    if interest_tag_found.nil? && (not interest_tag_name == '')
                      # Create new tag and add to this module
                      created_module.add_tag(InterestTag.create(name: interest_tag_name, type: 'InterestTag'))
                    else
                      # Already exists, so add to this module
                      created_module.add_tag(interest_tag_found)
                    end
                  end
                end

              end
            else
              # Update the existing Module
              if new_record['name'] == '' || new_record['name'].nil?
                flash[:error] = "Name update failed: Cannot update name of #{new_record['code']} to blank value"
              else
                created_module.update_attribute(:name, new_record['name'])
              end
              created_module.update_attribute(:description, new_record['description'])
              created_module.update_attribute(:lecturers, new_record['lecturers'])
              created_module.update_attribute(:pass_rate, new_record['pass_rate'])
              created_module.update_attribute(:assessment_methods, new_record['assessment_methods'])
              if ['1', '2', '1 or 2', '1 & 2'].include? new_record['semester']
                created_module.update_attribute(:semester, new_record['semester'])
              else
                flash[:error] = "Semester update verification failed: Semester of #{new_record['code']} must be '1', '2', '1 or 2' or '1 & 2'"
              end
              if new_record['credits'] == '' || new_record['credits'].nil?
                flash[:error] = "Credits update failed: Credits cannot be left blank"
              else
                created_module.update_attribute(:credits, new_record['credits'])
              end
              created_module.update_attribute(:exam_percentage, new_record['exam_percentage'])
              created_module.update_attribute(:coursework_percentage, new_record['coursework_percentage'])
              created_module.update_attribute(:more_info_link, new_record['more_info_link'])
              created_module.update_attribute(:assessment_dates, new_record['assessment_dates'])

              # Override module departments
              department_names = parse_mult_association_string(new_record['departments'])
              departments = []
              # Lookup department by department name
              department_names.each do |dept_name|
                # If department found then add to departments
                find_department = Department.find_by_name(dept_name)
                unless find_department.nil?
                  departments << find_department
                end
              end
              created_module.departments= departments

              # Override module prerequisite modules
              req_module_codes = parse_mult_association_string(new_record['prerequisite_modules'])
              req_modules = []
              req_module_codes.each do |module_code|
                # Lookup module by module code
                find_module = UniModule.find_by_code(module_code)
                # If module found then add to req modules
                unless find_module.nil?
                  req_modules << find_module
                end
              end
              created_module.uni_modules= req_modules

              # Override module tags
              tags = []
              # Retrieve career tags
              career_tag_names = parse_mult_association_string(new_record['career_tags'])
              career_tag_names.each do |career_tag|
                find_career_tag = CareerTag.find_by(name: career_tag)
                if find_career_tag.nil? && (not career_tag == '')
                  # Create the career tag
                  find_career_tag = CareerTag.create(name: career_tag)
                end
                # Add the new/existing tag to collection
                unless find_career_tag.nil?
                  tags << find_career_tag
                end
              end
              # Retrieve interest tags
              interest_tag_names = parse_mult_association_string(new_record['interest_tags'])
              interest_tag_names.each do |interest_tag|
                find_interest_tag = InterestTag.find_by(name: interest_tag)
                if find_interest_tag.nil? && (not interest_tag == '')
                  # Create the career tag
                  find_interest_tag = InterestTag.create(name: interest_tag)
                end
                # Add the new/existing tag to collection
                unless find_interest_tag.nil?
                  tags << find_interest_tag
                end
              end
              created_module.tags= tags

            end

          else
            session[:resource_name].to_s.classify.constantize.create!(new_record)
          end
        end
      end

      redirect_to :back
    end

  end
end