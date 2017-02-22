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
	    @module_names = UniModule.pluck(:name)
	    @module_code = UniModule.pluck(:code) 
		if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? 
	      @year_of_study = params[:year]
	      @course = params[:course]
	      @course_obj = Course.find_by_id(@course) 
	    else
	     redirect_to "/pathway-search/"
	    end
	end

	def view_results

		if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? && params.has_key?(:chosen_tags) && !params[:chosen_tags].empty?
      @year_of_study = params[:year]
      @course = params[:course]
      @chosen_tags = params[:chosen_tags].split(",")

      @structure = YearStructure.where("course_id = ? AND year_of_study = ?", @course, @year_of_study)
      @groups = Group.where("year_structure_id = ?", @structure.ids)

		  @course_obj = Course.find_by_id(@course) 
      	if !@course_obj.nil?
      		@results = UniModule.pathway_search(@chosen_tags, @course_obj) 
      	else
      	 	@results = {}
      	end

	    else
	     redirect_to "/pathway-search/"
	    end

	end

	def view_results_test
		if params.has_key?(:course)
			@course = Course.find_by_id(params[:course])
		else
	    	redirect_to "/pathway-search/"
		end
	end

end
