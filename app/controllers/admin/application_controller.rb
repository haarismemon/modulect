# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin

    include SessionsHelper

    def authenticate_admin
      
      # if not an admin, display a flash
      if logged_in? && !admin_user
         redirect_to root_path
         flash[:error] = "You are not logged in as an Administator. Please try again."
      # else go through old process of logging in
      elsif !admin_user
        store_location
        redirect_to admin_login_path
      end
    end

    def homepage

    end

    protected
      def make_data_store_nil
         session[:data_save] = nil
      end


    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end