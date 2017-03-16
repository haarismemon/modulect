module Admin
	class AnalyticsController < Admin::BaseController

		include AnalyticsHelper
		include SessionsHelper

		def analytics
			possible_times = ["day","week","month","year"]
			if params[:time].present? && possible_times.include?(params[:time])
				@time_period = params[:time]
			else
				@time_period = "month"
			end

			if current_user.user_level == "department_admin_access"
				@department = current_user.department_id.to_s
			elsif params[:department].present? && Department.exists?(params[:department].to_i) && current_user.user_level == "super_admin_access"
				@department = params[:department]
			elsif current_user.user_level == "super_admin_access"
				@department == "any"
			end

			if params[:course].present? && Course.exists?(params[:course].to_i)
				@course = Course.find(params[:course].to_i)
			else
				@course = "any"
			end
		end
		
	end
end