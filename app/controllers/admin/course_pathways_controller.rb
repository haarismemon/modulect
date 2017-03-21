module Admin
	class CoursePathwaysController < Admin::BaseController

  		# Controller handles the suggested pathways of the courses section

		# obtain reference to current course in show action
		def show
			@course = Course.find_by(id: params[:id])
		end

		# obtain reference to current course in new action
		def new_pathway
			@course = Course.find_by(id: params[:id])
		end

		# obtain reference to pathway in new action
		def edit
			@pathway = SuggestedPathway.find_by(id: params[:id])
		end		


	end
end