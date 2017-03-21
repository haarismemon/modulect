module Admin
	class CoursePathwaysController < Admin::BaseController
		def show
			@course = Course.find_by(id: params[:id])
		end

		def new_pathway
			@course = Course.find_by(id: params[:id])
		end

		def edit
			@pathway = SuggestedPathway.find_by(id: params[:id])
		end

		


	end
end