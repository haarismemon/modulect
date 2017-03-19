module Admin
  class UploadController < Admin::BaseController
    require 'csv'

    def upload
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
            Department.create!(new_record)

          elsif session[:resource_name] == 'faculties'
            # Faculties upload: Add departments attribute to create and/or link departments to the faculty
            # Create the faculty
            created_faculty = Faculty.create!(new_record.except('departments'))
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
                Department.create!(name: dept_name, faculty_id: created_faculty.id)
              else
                # Link department with this faculty
                department_found.update!(faculty_id: created_faculty.id)
              end
            end

          elsif session[:resource_name] == 'courses' || session[:resource_name] == 'uni_modules'
            # Add departments attribute to create and/or link departments to this course/module
            # Create the Course/Module
            created_resource = session[:resource_name].to_s.classify.constantize.create!(new_record.except('departments', 'prerequisite_modules'))
            # Transform string of departments into array of departments
            departments_s = new_record['departments']
            departments_s = departments_s.gsub('; ', ';')
            departments_a = departments_s.split(';')
            # For every entered department
            departments_a.each do |dept_name|
              # Look for a department with the name
              department_found = Department.find_by_name(dept_name)
              unless department_found.nil?
                # Add the found department to the departments the course/module belongs to
                created_resource.departments << department_found
              end
            end

            # If resource is modules then check for prerequisite modules
            if session[:resource_name] == 'uni_modules'
              # Transform string of modules into array
              pre_req_modules = new_record['prerequisite_modules']
              pre_req_modules = pre_req_modules.gsub('; ', ';')
              pre_req_modules = pre_req_modules.split(';')
              pre_req_modules.each do |module_name|
                module_found = UniModule.find_by_name(module_name)
                unless module_found.nil?
                  # Add the found module to this modules prerequisites
                  created_resource.uni_modules << module_found
                end
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
        # Add attribute for departments and prerequisite_modules
        resource_header << 'departments'
        resource_header << 'prerequisite_modules'
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

  end
end