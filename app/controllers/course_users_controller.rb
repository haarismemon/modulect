class CourseUsersController < ApplicationController

  def index
    @users = Course.find(params[:course_id]).users
    render("users/index")
  end
end
