class UsersController < ApplicationController

  # Display a list of all signed up users
  def index
    @users = User.all
  end

  # Display signup form.
  def new
    @user = User.new
  end

  # Handle signup form submission.
  def create
  end

  def destroy
  end

  private
    def user_creation_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end
end
