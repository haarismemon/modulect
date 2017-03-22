class PathwaySearchController < ApplicationController

  include PathwaySearchHelper

  # the begin action of the career search where the user can enter/edit their details
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

      if(@user.department_id.present?)
        @all_courses = Department.find_by_id(@user.department_id).courses
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
    if (params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? && params.has_key?(:chosen_tags) && !params[:chosen_tags].empty?) || (params.has_key?(:chosen_tags_c))
      @year_of_study = params[:year]
      @course = params[:course]
      @structure = YearStructure.where("course_id = ? AND year_of_study = ?", @course, @year_of_study)
      @groups = Group.where("year_structure_id = ?", @structure.ids)
      @course_obj = Course.find_by_id(@course)
      @chosen_tags = []
      @selected = []

      if params.has_key?(:selected) && !params[:selected].empty?
        @selected = params[:selected]
      end 

      # if using the checkboxes and search
      if params.has_key?(:chosen_tags) && params.has_key?(:chosen_tags_c)
        @chosen_tags = params[:chosen_tags].split(",") 
        params[:chosen_tags_c].each do |tag|
          @chosen_tags << tag
        end
        @chosen_tags = @chosen_tags.uniq
        # if just checkboxes
      elsif params.has_key?(:chosen_tags_c)
        params[:chosen_tags_c].each do |tag|
          @chosen_tags << tag
        end
      # if just search
      else
        @chosen_tags = params[:chosen_tags].split(",")         
      end

      @chosen_tags.each do |tag_name|
        if Tag.find_by_name(tag_name)
          add_to_tag_log(Tag.find_by_name(tag_name).id)
        end
      end

      if !@course_obj.nil?
        @results = UniModule.pathway_search(@chosen_tags, @course_obj) 
      else
        @results = {}
      end
    # if just viewing structure
    elsif (params.has_key?(:year) && !params[:year].empty? && params.has_key?(:course) && !params[:course].empty? )
      @year_of_study = params[:year]
      @course = params[:course]
      @structure = YearStructure.where("course_id = ? AND year_of_study = ?", @course, @year_of_study)
      @groups = Group.where("year_structure_id = ?", @structure.ids)
      @course_obj = Course.find_by_id(@course)
      @chosen_tags = []
      @selected = []
      @results = []

      if params.has_key?(:selected) && !params[:selected].empty?
        @selected = params[:selected]
      end
      @suggested_pathways = SuggestedPathway.where(course_id: @course_obj.id)

    else
      redirect_to "/pathway-search/"
    end
  end

  # add items to pathway search log counters
  def increment_pathway_search_log
    add_to_pathway_search_log(params[:first_mod_id], params[:second_mod_id], params[:course_id])
  end

  # remove items from pathway search log counters
  def decrement_pathway_search_log
    remove_from_pathway_search_log(params[:first_mod_id], params[:second_mod_id], params[:course_id])
  end

end
