module Admin

	class Admin::BaseController < ApplicationController
	before_action :authenticate_admin

	layout "admin/application"

   	include SessionsHelper
   	include ApplicationHelper

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


	end
	
end