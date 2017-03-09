module Admin
  class UploadController < Admin::ApplicationController
   
    def upload
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
      CSV.open("app/assets/admin_upload.csv", "wb") do |csv|
        # Add the attribute names as the header/first row
        csv << resource_header
      end

      # Debugging to check file has been generated correctly
      # CSV.foreach("admin_upload.csv") do |row|
      #   logger.debug(row)
      # end

      # Send the file for download
      send_file "app/assets/admin_upload.csv", :type=>"text/csv", :x_sendfile=>true
    end

  end
end
