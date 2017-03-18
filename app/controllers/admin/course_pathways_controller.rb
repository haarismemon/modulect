class Admin::CoursePathwaysController < ApplicationController
	def edit
		@course = Course.find_by(id: params[:id])
	end
end
