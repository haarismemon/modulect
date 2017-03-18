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
        # Reads each row of the uploaded csv file
        # Creates records for corresponding resource
        parsed_csv.each do |row|
          new_record = row.to_hash
          # When uploading departments, specify faculty name instead of id
          if session[:resource_name] == 'departments'
            # Lookup a faculty with matching name and retrieve it's ID
            new_record['faculty_id'] = Faculty.where(:name => row.to_hash['faculty_name']).first.id
            # Remove the faculty name attribute from row hash
            new_record = new_record.except('faculty_name')

          elsif session[:resource_name] == 'faculties'
            # Faculties upload: Add departments attribute to create and/or link departments to the faculty
            # Retrieve departments field from record
            departments_s = new_record['departments']
            logger.debug("&&&&&&&&&&&&&& #{departments_s}")
            # Normalise separators by removing whitespace
            departments_s = departments_s.gsub!('; ', ';')
            logger.debug("^^^^^^^^^^^^^ #{departments_s}")
            # Transform string of departments into array of departments
            departments_a = departments_s.split(';')
            logger.debug("[[[[[[]]]]]]]] #{departments_a}")
          end
          # session[:resource_name].to_s.classify.constantize.create!(new_record)
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
      # Add additional header attribute for the departments of the faculty
      if resource.to_s == 'faculties'
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

  end
end
