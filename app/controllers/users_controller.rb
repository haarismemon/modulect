class UsersController < ApplicationController

  # Display a list of all signed up users
  def index
    @users = User.all
  end

  # Displays signup form.
  # Signup forms will be posted to new instead of create to preserve /signup url.
  def new
    if user_params
      create
    else
      @user = User.new
    end
  end

  # Handle signup form submission.
  # User level is set to Student.
  def create
    @user = User.new(user_params)
    @user.user_level = 3
    if @user.save
      flash[:success] = "Account created successfully"
      redirect_to @user
    else
      render 'new'
    end
  end

  # Shows the profile of a user.
  def show
  end

  def destroy
  end

  private
    def user_params
      if params[:user].blank?
        return nil
      end
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end
end
