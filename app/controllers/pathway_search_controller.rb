class PathwaySearchController < ApplicationController

	def begin
	end

	def choose
		if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? 
	      @year_of_study = params[:year]
	      @course = params[:course]
	    else
	     redirect_to "/"
	    end
	end

	def view_results

		if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? && params.has_key?(:chosen_tags) && !params[:chosen_tags].empty?
	      @year_of_study = params[:year]
	      @course = params[:course]
	      @chosen_tags = params[:chosen_tags].split(",")

	      #change to course_id once available
	      @structure = YearStructure.where("course_id = ? AND year_of_study = ?", 1, params[:year])
	      @groups = Group.where("year_structure_id = ?", @structure.ids)

	      # results will be calculated here using haaris' function in the model
	      # right now i'll just use the existing basic search method

      		@results = UniModule.basic_search(@chosen_tags) # this will change!

	    else
	     redirect_to "/"
	    end

	end

end
