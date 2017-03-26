module Admin
  include SessionsHelper
  include ApplicationHelper
  include AdminHelper

	class Admin::BaseController < ApplicationController
	before_action :authenticate_admin
	before_action :admin_has_dept
	before_action :is_activated
	before_action :verify_super_admin, only: [:reset_modulect]
  
  # Controller handles the overall admin area of the application

	layout "admin/application"

   	include SessionsHelper
   	include ApplicationHelper
   	include AdminHelper

   # autenticate that the user is an admin 
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

  # verify that the admin has a department, if not show a flash
	def admin_has_dept
		if logged_in? && admin_user && current_user.user_level == "department_admin_access" && !current_user.department_id.present?
			log_out
			redirect_to root_path
	        flash[:error] = "You have not been assigned a department. Contact the System Administrator."
		end
	end
	
  # check that the user's account has been activated
	def is_activated
		if !current_user.activated
			log_out
			redirect_to root_path
			flash[:error] = "You have been logged out."
		end
	end

  # allows super admins to reset modulect completely by resetting all the database tables/models
  def reset_modulect
    password_received = params[:dwp]
    if current_user.is_password?(password_received)

      Comment.delete_all
      Course.delete_all
      Department.delete_all
      Faculty.delete_all
      Group.delete_all
      Pathway.delete_all
      Tag.delete_all
      UniModule.delete_all
      User.where(:user_level => "user_access").delete_all
      User.where(:user_level => "department_admin_access").delete_all
      YearStructure.delete_all
      PathwaySearchLog.delete_all
      Notice.delete_all
      SearchLog.delete_all
      TagLog.delete_all
      UniModuleLog.delete_all
      VisitorLog.delete_all
      SuggestedPathway.delete_all
      SavedModule.delete_all

      # set settings back to default
      app_settings.update_attributes(:offline_message => "", :allow_new_registration => true, :tag_percentage_match => 60.0, :disable_new_reviews => false, :disable_all_reviews => false)

      # only super admins left, so to prevent nullpointers, set their ids to nil
      User.all.each do |user|
      	user.update_attributes(:faculty_id => nil, :department_id => nil, :course_id => nil)
      end

      flash[:success] = "Modulect has succesfully been reset."
    else
     	flash[:error] = "The password you entered was incorrect."
    end
    head :no_content
  end

  private 

  # verify that a user is a super admin
  def verify_super_admin
    redirect_to admin_path unless current_user.user_level == "super_admin_access"
  end


	end
end

