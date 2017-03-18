module Admin
	class CoursePathwaysController < Admin::BaseController
		def index
			@course = Course.find_by(id: params[:id])
		end

		def new_pathway
			@course = Course.find_by(id: params[:id])
		end
	end
end