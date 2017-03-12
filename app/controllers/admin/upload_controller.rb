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
        case session[:resource_name]
          when 'courses'
            Course.create!(row.to_hash)
          when 'departments'
            Department.create!(row.to_hash)
          when 'faculties'
            Faculty.create!(row.to_hash)
          when 'uni_modules'
            UniModule.create!(row.to_hash)
          when 'users'
            User.create!(row.to_hash)
          when 'year_structures'
            YearStructure.create!(row.to_hash)
        end
      end

      # Return nothing
      head :no_content
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

      # Will store the attribute names of the resource
      resource_header = []

      # Retrieves the attribute names depending on resource
      case resource.to_s
        when 'courses'
          resource_header = Course.attribute_names
        when 'departments'
          resource_header = Department.attribute_names
        when 'faculties'
          resource_header = Faculty.attribute_names
        when 'uni_modules'
          resource_header = UniModule.attribute_names
        when 'users'
          resource_header = User.attribute_names
        when 'year_structures'
          resource_header = YearStructure.attribute_names
      end

      # Remove attributes that shouldn't appear on CSV
      to_remove = ['id', 'created_at', 'updated_at']
      resource_header = resource_header - to_remove

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
