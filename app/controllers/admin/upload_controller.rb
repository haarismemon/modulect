module Admin
  class UploadController < Admin::BaseController
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
        resource_header << 'departments'
        resource_header << 'prerequisite_modules'
        resource_header << 'career_tags'
        resource_header << 'interest_tags'
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
            new_record['faculty_id'] = Faculty.where(name: row.to_hash['faculty_name']).first.id
            # Remove the faculty name attribute from row hash
            new_record = new_record.except('faculty_name')
            # Check whether to update a department or create a new one
            if Department.find_by_name(new_record['name']).nil?
              Department.create!(new_record)
            else
              Department.update(new_record)
            end

          elsif session[:resource_name] == 'faculties'
            # Faculties upload: Add departments attribute to create and/or link departments to the faculty
            faculty_entry = nil
            # Check whether to update a faculty or create a new one
            if Faculty.find_by_name(new_record['name']).nil?
              # Create a new faculty
              faculty_entry = Faculty.create!(new_record.except('departments'))
            else
              # Retrieve the existing faculty
              faculty_entry = Faculty.find_by_name(new_record['name'])
            end
            # Transform string of departments into array of departments
            departments_s = new_record['departments']
            departments_s = departments_s.gsub('; ', ';')
            departments_a = departments_s.split(';')
            # For every entered department
            departments_a.each do |dept_name|
              # Look for a department with the name
              department_found = Department.find_by_name(dept_name)
              if department_found.nil?
                # Create and link department with the this faculty
                Department.create!(name: dept_name, faculty_id: faculty_entry.id)
              else
                # Link department with this faculty
                department_found.update!(faculty_id: faculty_entry.id)
              end
            end

          elsif session[:resource_name] == 'courses'
            # Add departments attribute to create and/or link departments to this course
            # Lookup if Course already exists: Course is unique by name + year combo
            created_course = Course.find_by(name: new_record['name'], year: new_record['year'])
            if created_course.nil?
              # Create the Course
              created_course = Course.create!(new_record.except('departments'))
            else
              # Update the existing Course
              created_course.update(new_record.except('departments'))
            end
            # Transform string of departments into array of departments
            departments_s = new_record['departments']
            departments_s = departments_s.gsub('; ', ';')
            departments_a = departments_s.split(';')
            # For every entered department
            departments_a.each do |dept_name|
              # Look for a department with the name
              department_found = Department.find_by_name(dept_name)
              unless department_found.nil?
                # Add the found department to the departments the course belongs to
                created_course.departments << department_found
              end
            end

          elsif session[:resource_name] == 'uni_modules'
            # Add departments attribute to create and/or link departments to this module
            # Lookup if Module already exists: Module is unique by Code
            created_module = UniModule.find_by_code(new_record['code'])
            if created_module.nil?
              # Create the Module
              logger.debug('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO MODULE CREATED')
              created_module = UniModule.create!(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags'))
            else
              logger.debug('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO MODULE UPDATED')
              # Update the existing Module
              created_module.update(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags'))
            end
            # Transform string of departments into array of departments
            departments_s = new_record['departments']
            departments_s = departments_s.gsub('; ', ';')
            departments_a = departments_s.split(';')
            # For every entered department
            departments_a.each do |dept_name|
              # Look for a department with the name
              department_found = Department.find_by_name(dept_name)
              unless department_found.nil?
                # Add the found department to the departments the module belongs to
                created_module.departments << department_found
              end
            end

            # Add prerequisite modules
            # Transform string of modules into array
            pre_req_modules = new_record['prerequisite_modules']
            pre_req_modules = pre_req_modules.gsub('; ', ';')
            pre_req_modules = pre_req_modules.split(';')
            pre_req_modules.each do |module_name|
              module_found = UniModule.find_by_name(module_name)
              unless module_found.nil?
                # Add the found module to this modules prerequisites
                created_module.uni_modules << module_found
              end
            end

            # Add career_tags
            career_tags = new_record['career_tags']
            career_tags = career_tags.gsub('; ', ';')
            career_tags = career_tags.split(';')
            career_tags.each do |career_tag_name|
              # Lookup if tag with same name exists already
              career_tag_found = CareerTag.find_by(name: career_tag_name, type: 'CareerTag')
              if career_tag_found.nil?
                # Create new tag and add to this module
                created_module.add_tag(CareerTag.create!(name: career_tag_name, type: 'CareerTag'))
              else
                # Already exists, so add to this module
                created_module.add_tag(career_tag_found)
              end
            end

            # Add interest_tags
            interest_tags = new_record['interest_tags']
            interest_tags = interest_tags.gsub('; ', ';')
            interest_tags = interest_tags.split(';')
            interest_tags.each do |interest_tag_name|
              # Lookup if tag with same name exists already
              interest_tag_found = InterestTag.find_by(name: interest_tag_name, type: 'InterestTag')
              if interest_tag_found.nil?
                # Create new tag and add to this module
                created_module.add_tag(InterestTag.create!(name: interest_tag_name, type: 'InterestTag'))
              else
                # Already exists, so add to this module
                created_module.add_tag(interest_tag_found)
              end
            end

          else
            session[:resource_name].to_s.classify.constantize.create!(new_record)
          end
        end

        flash[:success] = "Processed #{parsed_csv.length} new #{session[:resource_name]}"
      end

      redirect_to :back
    end

  end
end