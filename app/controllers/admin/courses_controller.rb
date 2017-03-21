module Admin
  class CoursesController < Admin::BaseController
    include CoursesHelper

    before_action :verify_correct_department, only: [:update, :edit, :destroy]

    def course_pathways
      @course = Course.find_by(id: params[:id])
    end
    def show
      redirect_to edit_admin_course_path(params[:id])
    end

    def index
      if current_user.user_level == "super_admin_access"
         if params[:dept].present? && params[:dept].to_i != 0 && Department.exists?(params[:dept].to_i)
          @dept_filter_id = params[:dept].to_i
          @courses = Department.find(@dept_filter_id).courses
        else
          @courses = Course.all 
        end
      else
        @courses = Department.find(current_user.department_id).courses
      end

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end 


      if params[:search].present?
        @search_query = params[:search]
        @courses = @courses.select { |course| course.name.downcase.include?(params[:search].downcase) }.sort_by{|course| course[:name]}

        @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(@per_page)
      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @courses = sort(Course, @courses, @sort_by, @order, @per_page, "name")
        @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(@per_page)

      else
         @courses = @courses.order('name ASC').page(params[:page]).per(@per_page)
      end

      if @courses.size == 0 && params[:page].present? && params[:page] != "1"
        redirect_to admin_courses_path
      end

      @courses_to_export = @courses
      if params[:export].present?
        export_course_ids_string = params[:export]
        export_course_ids = eval(export_course_ids_string)

        if current_user.user_level == "department_admin_access"
          department_course_ids = Department.find(current_user.department_id).course_ids
          export_course_ids = export_course_ids & department_course_ids.map(&:to_s)
        end

        @courses_to_export = Course.where(id: export_course_ids)
        @courses_to_export = @courses_to_export.order('LOWER(name) ASC')  
      else
        @courses_to_export = @courses
      end

      respond_to do |format|
        format.html
        format.csv {send_data @courses_to_export.to_csv}
      end

    end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(course_params)
      if @course.save
        @course.create_year_structures
        flash[:success] = "Successfully created " + @course.name
        redirect_to(edit_admin_course_path @course)
      else
        render('new')
      end
    end

    def edit
      @course = Course.find_by(id: params[:id])
    end

    def update
      @course = Course.find(params[:id])
      duration_in_years_pre_update = @course.duration_in_years
      if @course.update_attributes course_params
        @course.update_year_structures(duration_in_years_pre_update)
        flash[:success] = "Successfully updated #{@course.name}"
        redirect_to edit_admin_course_path(@course)
      else
        render 'edit'
      end
    end

    def destroy
      @course = Course.find(params[:id])

      @course.year_structures.each do |year_structure|
        Group.where(year_structure_id: year_structure.id).destroy_all
      end
      YearStructure.where(course_id: @course.id).destroy_all

      @course.users.each do |user|
        user.update_attribute("course_id", nil)
      end

      pathway_search_logs = PathwaySearchLog.all.where(:course_id => @course.id)
          if pathway_search_logs.size >0
            pathway_search_logs.each do |log|
                pathway_search_logs.destroy
            end
          end  

      @course.destroy
      flash[:success] =  "Successfully deleted " + @course.name
      redirect_to(admin_courses_path)
    end


    def bulk_delete
      course_ids_string = params[:ids]
      course_ids = eval(course_ids_string)

      course_ids.each do |id|
        course = Course.find(id.to_i)
          if !course.nil?
            course.year_structures.each do |year_structure|
              Group.where(year_structure_id: year_structure.id).destroy_all
            end
            YearStructure.where(course_id: course.id).destroy_all
             pathway_search_logs = PathwaySearchLog.all.where(:course_id => course.id)
              if pathway_search_logs.size >0
                pathway_search_logs.each do |log|
                    pathway_search_logs.destroy
                end
              end 
            course.destroy
          end
      end

      head :no_content
    end


    def clone
      course_ids_string = params[:ids]
      deep_clone_courses_with_ids(course_ids_string)
      head :no_content
    end


    private
    def course_params
      params.require(:course).permit(:name, :description,
                  :duration_in_years, :year, department_ids: [],
                  year_structures_attributes: [:id, :year_of_study, :_destroy])
    end

    def verify_correct_department
      @course = Course.find(params[:id])
      if (current_user.user_level == "department_admin_access" &&
          !Department.find(current_user.department_id).course_ids.include?(@course.id))
        redirect_to admin_path
      end
    end
  end
end
