class PathwaySearchController < ApplicationController

	def begin
	end

	def choose
		@tag_names = Tag.pluck(:name)
	    @module_names = UniModule.pluck(:name)
	    @module_code = UniModule.pluck(:code) 
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

	      # results will be calculated here using haaris' function in the model
	      # right now i'll just use the existing basic search method

      		@results = UniModule.basic_search(@chosen_tags) # this will change!

	    else
	     redirect_to "/"
	    end

	end

end
