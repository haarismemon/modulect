class CareerSearchController < ApplicationController
	include CareerSearchHelper

	def begin
    	@faculties = Faculty.all
    	@departments = {}
    	@courses = {}

    	if logged_in?
    		@user = current_user
		    #Initialise departments and courses to be empty unless previously selected
		     if(@user.department_id.present?)
		      @departments = Faculty.find_by_id(@user.faculty_id).departments
		    else
		      @departments = {}
		    end
		    if(@user.department_id.present? && @user.course_id.present?)
		      @courses = Department.find_by_id(@user.department_id).courses
		    else
		      @courses = {}
		    end
		end
	end

	  


  def choose
    if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? 
       @year_of_study = params[:year]
          @course = params[:course]
          @course_obj = Course.find_by_id(@course) 
    else
      redirect_to career_search_path
    end
  end

  def view_results
  	if params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? && params.has_key?(:chosen_modules) && !params[:chosen_modules].empty? 
  		  @year_of_study = params[:year]
	      @course = params[:course]
	      @chosen_modules = params[:chosen_modules]
	      @course_obj = Course.find_by_id(@course) 

	      @uni_modules_array = []
	      @chosen_modules.each do |unimodule|
	      	current_uni_module = UniModule.find_by_code(unimodule)
	      	if !current_uni_module.nil?
	      		@uni_modules_array << current_uni_module
	      	end
	      end	
	      @careers_found = get_career_tags_from_modules(@uni_modules_array)

	else
		#redirect_to "/career-search/"
	end
  end
end
