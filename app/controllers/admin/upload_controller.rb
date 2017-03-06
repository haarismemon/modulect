module Admin
  class UploadController < Admin::ApplicationController
   
    def upload
    end

    def download
      resource_name = params[:resource_choice]
      require 'csv'

      resource = nil

      Administrate::Namespace.new(namespace).resources.each do |administrate_resource|
        if administrate_resource.to_s == resource_name
          resource = administrate_resource
        end
      end

      logger.debug(resource)

      # CSV.open("#{resource_name}_upload.csv") do |csv|
      #   csv << ["animal", "count", "price"]
      #   csv << ["fox", "1", "$90.00"]
      # end

      head :no_content
    end

  end
end
