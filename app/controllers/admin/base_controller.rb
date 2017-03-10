module Admin

	class Admin::BaseController < ApplicationController
	before_action :authenticate_admin
	before_action :admin_has_dept

	layout "admin/application"

   	include SessionsHelper
   	include ApplicationHelper
   	include AdminHelper

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


	def admin_has_dept
		if logged_in? && admin_user && current_user.user_level == "department_admin_access" && !current_user.department_id.present?
			redirect_to root_path
	        flash[:error] = "You have not been assigned a department. Contact the System Administrator."
		end
	end
	


	end
end