class PathwaySearchController < ApplicationController


	def begin
    	@faculties = Faculty.all
    	@departments = {}
    	@courses = {}

    	if logged_in?
    		@user = current_user
		    #Initialise departments and courses to be empty unless previously selected
		    if(@user.department_id.present?)
		      @departments = Department.where("id = ?", @user.department_id)
		    end
		    if(@user.course_id.present?)
		      @courses = Course.where("id = ?", @user.course_id)
		    end
		end
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
