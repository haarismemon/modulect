module Admin
  class UploadController < Admin::ApplicationController
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

      # Reads each row of the uploaded csv file
      csv_text = File.read('app/assets/uploaded.csv')
      parsed_csv = CSV.parse(csv_text, headers: true)
      parsed_csv.each do |row|
        # Creates records for corresponding resource
        # TO-DO: find faculty from read faculty ID and replace in row Faculty.find(dept.name).id
        if session[:resource_name] == 'faculties'
          facultyRow = row.to_hash
          logger.debug("***************#{facultyRow['name']}")
        end
        # TO-DO: When uploading faculty csv, add department header, and for every department name add the department ID see: faculties.rb
        # TO-DO: Unimodules upload add interest tags, career tags, create tag - in unimodule controller
        session[:resource_name].to_s.classify.constantize.create!(row.to_hash)
      end

      flash[:success] = "Processed #{parsed_csv.length} new #{session[:resource_name]}"
      redirect_to :back

    end

    def download
      # Retrieve the resource requested to upload e.g Users
      resource_name = params[:resource_choice]
      # Will store verified resource
      resource = nil

      # Verify that the resource with the corresponding name exists
      Administrate::Namespace.new(namespace).resources.each do |administrate_resource|
        if administrate_resource.to_s == resource_name
          resource = administrate_resource
        end
      end

      # Store the resource as a session variable
      session[:resource_name] = resource.to_s

      # Retrieves the attribute names depending on resource
      resource_header = resource.to_s.classify.constantize.attribute_names

      # Remove attributes that shouldn't appear on CSV
      to_remove = %w(id created_at updated_at)
      resource_header = resource_header - to_remove

      # Add specific association attributes
      # Add additional header for the departments of the faculty
      if resource.to_s == 'faculties'
        resource_header << "departments"
        logger.debug("8888888888888888888 #{resource_header}")
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
