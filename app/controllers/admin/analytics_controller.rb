module Admin
	class AnalyticsController < Admin::BaseController
    # Controller handles the analytics in the admin area of the site.

		include AnalyticsHelper
		include SessionsHelper

    before_filter :analytics

    # The main action handling the main area of the analytics, including setting of a department, course, time period. Also handles the search. See inline comments for details
		def analytics
      # the time periods which can be sorted by
			@possible_times = ["day","week","month","year", "all_time"]
			if params[:time].present? && @possible_times.include?(params[:time])
				@time_period = params[:time]
			else
				@time_period = "month" # default
			end

      # for department admins, we show only modules in their department. for system admins we show every module (uni_module)
			if current_user.user_level == "department_admin_access"
				@department = current_user.department_id.to_s
        @courses = Department.find(current_user.department_id).courses
        @uni_modules = {}
        @uni_module = {}
      elsif current_user.user_level == "super_admin_access"
        @faculties = Faculty.all
        @departments = {} # Note this is used for the pathway search drop downs
        @courses = {}
        @uni_modules = {}
        @uni_module = {}

        # if the user tried to search verify that they are a super admin (only super admins can search). searching allows a super admin to quickly find departments
  			if params[:search].present? && current_user.user_level == "super_admin_access"
      		@deparments_list = Department.all.select { |department| department.name.downcase.include?(params[:search].downcase) }
      		if @deparments_list.size == 1 # single department found
      			@department = @deparments_list.first.id.to_s
      			flash[:success] = "Succesfully found " + Department.find(@department.to_i).name
      		elsif @deparments_list.size > 1 # too many
      			flash[:error] = "Your query resulted in too many deparments. Please be more specific with your search query."
      			@department = "any"
      		else 
      			flash[:error] = "No departments found for your search query."
      			@department = "any"
      		end
          # otherwise, show all departments' data
  			elsif params[:department].present? && Department.exists?(params[:department].to_i) && current_user.user_level == "super_admin_access"
  				@department = params[:department]
  			elsif current_user.user_level == "super_admin_access"
  				@department = "any"
  			end
      end


      # FERAS THIS IS NEW STUFF FROM THE BIG FIX, REMOVE THIS COMMENT WHEN READ 
      if current_user.user_level == "super_admin_access"
        if @department != "any"
          department_id = @department.to_i
          @all_uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id))}
          @all_users = users = User.all.select { |user| user.department_id == department_id && user.user_level == "user_access"}
        else 
          @all_uni_modules = UniModule.all
          @all_users = User.all
        end
      else
        @all_uni_modules = UniModule.all.select { |uni_module| uni_module.departments.include?(Department.find(department_id.to_i))}
        @all_users = users = User.all.select { |user| user.department_id == department_id.to_i && user.user_level == "user_access"}
      end



			
		end

    # Change the value of the modules dropdown if course changes
    def update_modules
      @course = Course.find(params[:course_id])
      @uni_modules = []
      @course.year_structures.each do |year|
        year.groups.each do |group|
          group.uni_modules.each do |mod|
            @uni_modules << mod
          end
        end
      end
      respond_to do |format|
        format.js
      end
    end

    # update the value of the module selected
    def update_selected_module
      @uni_module = UniModule.find(params[:module_id])
      @course = Course.find(params[:course_id])
      @chart_type = params[:chart_type]
      respond_to do |format|
        format.js
      end
    end

    # update the value of the department selected
    def update_selected_department
      @department = Department.find(params[:department_id])
    end
		
	end
end