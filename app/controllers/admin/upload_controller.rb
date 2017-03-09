module Admin
  class UploadController < Admin::ApplicationController

    def upload
    end

    def upload_csv
      # Retrieve csv file that was uploaded
      uploaded_csv = params[:csv_upload]
      # Debugging: Write uploaded CSV to app/assets/uploaded
      File.open(Rails.root.join('app', 'assets', 'uploaded.csv'), 'wb') do |file|
        file.write(uploaded_csv.read)
      end
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

      # Will store the attribute names of the resource
      resource_header = []

      # Retrieves the attribute names depending on resource
      case resource.to_s
        when "courses"
          resource_header = Course.attribute_names
        when "departments"
          resource_header = Department.attribute_names
        when "faculties"
          resource_header = Faculty.attribute_names
        when "uni_modules"
          resource_header = UniModule.attribute_names
        when "users"
          resource_header = User.attribute_names
        when "year_structures"
          resource_header = YearStructure.attribute_names
      end

      # Create a CSV file in the specified path
      require 'csv'
      file_name = "app/assets/#{resource.to_s}_upload.csv"
      CSV.open(file_name, "wb") do |csv|
        # Add the attribute names as the header/first row
        csv << resource_header
      end

      # Send the file for download
      send_file file_name, :type=>"text/csv", :x_sendfile=>true
    end

  end
end
