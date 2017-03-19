module Admin
	class AnalyticsController < Admin::BaseController

		include AnalyticsHelper
		include SessionsHelper

		def analytics
			@possible_times = ["day","week","month","year", "all_time"]
			if params[:time].present? && @possible_times.include?(params[:time])
				@time_period = params[:time]
			else
				@time_period = "month"
			end

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
  			if params[:search].present? && current_user.user_level == "super_admin_access"
      		@deparments_list = Department.all.select { |department| department.name.downcase.include?(params[:search].downcase) }
      		if @deparments_list.size == 1
      			@department = @deparments_list.first.id.to_s
      			flash[:success] = "Succesfully found " + Department.find(@department.to_i).name
      		elsif @deparments_list.size > 1
      			flash[:error] = "Your query resulted in too many deparments. Please be more specific"
      			@department = "any"
      		else 
      			flash[:error] = "No departments found"
      			@department = "any"
      		end
  			elsif params[:department].present? && Department.exists?(params[:department].to_i) && current_user.user_level == "super_admin_access"
  				@department = params[:department]
  			elsif current_user.user_level == "super_admin_access"
  				@department = "any"
  			end
      end

			if params[:course].present? && Course.exists?(params[:course].to_i)
				@course = Course.find(params[:course].to_i)
			else
				@course = "any"
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
    end

    # update the value of the department selected
    def update_selected_department
      @department = Department.find(params[:department_id])
    end
		
	end
end