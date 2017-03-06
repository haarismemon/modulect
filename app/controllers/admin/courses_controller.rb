module Admin
  class CoursesController < Admin::BaseController

    def index
      @courses = Course.alphabetically_order_by(:name)
    end

    def new
    end

    def create
    end

    def edit
    end

    def update
    end

    def destroy
      #find by id
      @course = Course.find(params[:id])
      #delete tuple object from db
      @course.destroy
      flash[:notice] =  @course.name + " was deleted successfully."
      #redirect to action which displays all courses
      redirect_to(admin_courses_path)
    end

  end
end
