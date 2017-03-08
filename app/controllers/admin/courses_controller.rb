module Admin
  class CoursesController < Admin::BaseController

    def index
      @courses = Course.paginate(page: params[:page], :per_page => 20)
                          .alphabetically_order_by(:name)
    end

    def show
      redirect_to edit_admin_course_path(params[:id])
    end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(course_params)
      if @course.save
        for y in 1..@course.duration_in_years
          @course.year_structures << YearStructure.new(year_of_study: y)
        end
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
      # TODO: Handle the duration_in_years update properly
      @course = Course.find(params[:id])
      if @course.update_attributes course_params
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
