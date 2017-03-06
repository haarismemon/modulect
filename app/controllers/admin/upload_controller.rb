module Admin
  class UploadController < Admin::ApplicationController
   
    def upload
    end

    def download
      resource_name = params[:resource_choice]
      require 'csv'

      resource = nil

      head :no_content
    end

  end
end
