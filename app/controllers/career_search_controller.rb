class CareerSearchController < ApplicationController

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
	if params.has_key?(:course) && !params[:course].empty? 
	      @course = params[:course]
	      @course_obj = Course.find_by_id(@course) 
	else
		redirect_to "/career-search/"
	end
  end

  def view_results
  	if params.has_key?(:course) && !params[:course].empty? 
	      @course = params[:course]
	      @course_obj = Course.find_by_id(@course) 
	else
		redirect_to "/career-search/"
	end
  end
end
