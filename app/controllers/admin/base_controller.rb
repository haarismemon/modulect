module Admin
  include SessionsHelper
  include ApplicationHelper
  include AdminHelper

	class Admin::BaseController < ApplicationController
    before_action :authenticate_admin
    before_action :admin_has_dept
    before_action :is_activated

    layout "admin/application"
    
    def authenticate_admin
      if logged_in? && !admin_user
         redirect_to root_path
         flash[:error] = "You are not logged in as an Administator. Please try again."
      elsif !admin_user
        store_location
        redirect_to admin_login_path
      end
    end

    def admin_has_dept
      if logged_in? && admin_user && current_user.user_level == "department_admin_access" && !current_user.department_id.present?
        log_out
        redirect_to root_path
            flash[:error] = "You have not been assigned a department. Contact the System Administrator."
      end
    end
    
    def is_activated
      if !current_user.activated
        log_out
        redirect_to root_path
        flash[:error] = "You have been logged out."
      end
    end
  end
end
