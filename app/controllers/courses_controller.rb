class CoursesController < ApplicationController

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
      redirect_to(courses_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render('edit')
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name,:description)
    end
end
