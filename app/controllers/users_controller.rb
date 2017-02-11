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
  # User level is set to Student.
  def create
    @user = User.new(user_params)
    @user.user_level = 3
    if @user.save
      flash[:success] = "Account created successfully"
      redirect_to users_url
    else
      render 'new'
    end
  end

  def destroy
  end

  private
    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end
end
