class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  def edit
    #! looks for object to ready populate form with the associated tag's data ready for modification by admin
    @course = Course.find(params[:id])
  end



  def create
    @course = Course.new(course_params)
    # Save the object
    if @course.save
      # If save succeeds, redirect to the index action
      flash[:notice] = @course.name+" was created successfully."
      redirect_to(courses_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end
  end

  def update
    # Find a new object using form parameters
    @course = Course.find(params[:id])
    # Update the object
    if @course.update_attributes(course_params)
      # If save succeeds, redirect to the show action
      flash[:notice] = @course.name+" was updated successfully."
      redirect_to(course_path(@course))
    else
      # If save fails, redisplay the form so user can fix problems
      render('edit')
    end
end


  def destroy
    #find by id
    @course = Course.find(params[:id])
    #delete tuple object from db
    @course.destroy
    flash[:notice] =  @course.name+"was deleted successfully."
    #redirect to action which displays all courses
    redirect_to(courses_path)
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.fetch(:course, {})
    end
end
