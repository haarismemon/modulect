module Admin
  class CoursesController < Admin::BaseController

    def show
      redirect_to edit_admin_course_path(params[:id])
    end

    def index
      if current_user.user_level == "super_admin_access"
        @courses = Course.all
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
        @courses = @courses.select { |course| course.name.downcase.include?(params[:search].downcase) }.sort_by{|course| course[:name]}.paginate(page: params[:page], :per_page => @per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @courses = sort(Course, @courses, @sort_by, @order, @per_page, "name")
      else
        @courses = @courses.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
      end

      respond_to do |format|
        format.html
        format.csv {send_data @courses.to_csv}
      end

    end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(course_params)
      if @course.save
        @course.create_year_structures
        flash[:notice] = @course.name+ " was created successfully. "
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
        flash[:notice] = "#{@course.name} successfully updated."
        redirect_to edit_admin_course_path(@course)
      else
        render 'edit'
      end
    end

    def destroy
      @course = Course.find(params[:id])
      @course.destroy
      flash[:notice] =  @course.name + " was deleted successfully."
      redirect_to(admin_courses_path)
    end

    private
    def course_params
      params.require(:course).permit(:name, :description,
                  :duration_in_years, :year, department_ids: [],
                  year_structures_attributes: [:id, :year_of_study, :_destroy])
    end
  end
end
