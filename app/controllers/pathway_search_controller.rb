class PathwaySearchController < ApplicationController

		# Change the value of @departments if faculty changes
	  def update_departments
	    @departments = Department.where("faculty_id = ?", params[:faculty_id])
	                  respond_to do |format|
	                    format.js
	                  end
	  end

	  # Change the value of @courses if department changes
	  def update_courses
	    d = Department.find(params[:department_id])
	    @courses = d.courses.where("department_id = ?", params[:department_id])
	                    respond_to do |format|
	                      format.js
	                    end
	  end

	def begin
    	@faculties = Faculty.all
    	@departments = Department.all
    	@courses = Course.all
	end

	def choose
		# the variables are only used if the user is not logged in
		# because in that case I read it directly
		# from the user model
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
