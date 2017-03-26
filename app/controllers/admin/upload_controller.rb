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
      session[:template_path] = file_name

      CSV.open(file_name, 'wb') do |csv|
        # Add the attribute names as the header/first row
        csv << resource_header
      end

      # Send the file for download
      send_file file_name, type: 'text/csv', x_sendfile: true
    end

    def upload_csv
      # Retrieve the CSV object
      uploaded_csv = params[:csv_upload]

      # Set the filepath and name of the file to be uploaded
      file_path = Rails.root.join('app', 'assets', "uploaded_#{current_user.id}.csv")

      # Write the uploaded CSV object to the path
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_csv.read)
      end

      # Extract the text and send for processing
      csv_text = File.read(file_path)
      uploader = current_user
      parse_csv_and_display_notice(csv_text, session[:resource_name], session[:resource_header], uploader)

      # Delete generated files after processing upload
      File.delete(file_path)
      File.delete(session[:template_path])

      redirect_to :back
    end
  end
end
