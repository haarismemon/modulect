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
      uploaded_csv = params[:csv_upload]

      File.open(Rails.root.join('app', 'assets', 'uploaded.csv'), 'wb') do |file|
        file.write(uploaded_csv.read)
      end

      csv_text = File.read('app/assets/uploaded.csv')
      parsed_csv = CSV.parse(csv_text, headers: true)
      uploaded_header = parsed_csv.headers

      if parsed_csv.length == 0
        flash[:error] = 'Upload Failed: No records found. CSV is empty'
      elsif uploaded_header != session[:resource_header]
        flash[:error] = 'Upload Failed: Please ensure the CSV header matches the template file'
      else
        if session[:resource_name] == 'departments'
          creations, updates = upload_departments(parsed_csv)
        elsif session[:resource_name] == 'faculties'
          creations, updates = upload_faculties(parsed_csv)
        elsif session[:resource_name] == 'courses'
          creations, updates = upload_courses(parsed_csv)
        elsif session[:resource_name] == 'uni_modules'
          creations, updates = upload_uni_modules(parsed_csv)
        else
          flash[:notice] = 'Resource not recognized'
        end
      end

      creations ||= 0
      updates ||= 0

      flash[:success] = "Upload complete: Processed #{creations} creations, #{updates} updates"
      redirect_to :back
    end
  end
end
