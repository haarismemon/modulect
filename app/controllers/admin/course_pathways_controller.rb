module Admin
	class CoursePathwaysController < Admin::BaseController
		def index
			@course = Course.find_by(id: params[:id])
		end

		def new_pathway
		end
	end
end