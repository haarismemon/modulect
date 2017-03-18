module Admin
	class CoursePathwaysController < Admin::BaseController
		def edit
			@course = Course.find_by(id: params[:id])
		end
	end
end