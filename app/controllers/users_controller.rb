class UsersController < ApplicationController

  skip_before_action :store_location,
                      only: [:new, :edit]

  def index
    #returns all users by order of last_name
    @users = User.alphabetically_order_by(:last_name)
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

  def create_by_admin
    # Instantiate a new object using form parameters
    @user = User.new(user_params)
    # Save the object
    if @user.save
      # If save succeeds, redirect to the index action
      flash[:success] = "You have successfully created #{@user.full_name} and it's privileges have been granted"
      redirect_to(users_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render(:new)

    end
  end

  # Handle signup form submission.
  # User level is set to Student.
  def create
    @user = User.new(user_params)
    @user.user_level = 3
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      redirect_to "/"
      flash[:success] = "Please check your email to activate your account."
    else
      render 'new'
    end
  end

  def edit
    #! allows for template's form to be ready populated with the associated users data ready for modification by admin
    @user = User.find(params[:id])
    # Get arrays to use for profiles
    @faculties = Faculty.all
    #Initialise departments and courses to be empty
    @departments = {}
    @courses = {}
  end

  # Change the value of @departments if faculty changes
  def update_departments
    @departments = Department.where("faculty_id = ?", params[:faculty_id])
                  respond_to do |format|
                    format.js
                  end
  end

  # Change the value of @courses if department changes
  def update_courses
    d = Department.find(params[:department_id])
    @courses = d.courses.where("department_id = ?", params[:department_id])
                    respond_to do |format|
                      format.js
                    end
  end

  def update
    @user = User.find(params[:id])
    @user.updating_password = false
    if @user.update_attributes(update_params)
      # If save succeeds, redirect to the index action
      flash[:success] = "Successfully updated "+ @user.full_name
      redirect_to(root_path) and return
    else
      # If save fails, restart form and notify user
      flash[:error] = "Please check that you have entered your details correctly and try again."
      render 'edit'
    end
  end

  def destroy
    #find by id
    @user = User.find(params[:id])
    #delete tuple object from db
    @user.destroy
    flash[:success] = @user.full_name+" has been deleted successfully."
    #redirect to action which displays all users
    redirect_back_or users_path
  end

  private
    def user_params
      if params[:user].blank?
        return nil
      end
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study, :user_level, :course_id)
    end

    # Used when updating the profile
    def update_params
      params.require(:user).permit(:password, :faculty_id, :department_id, :course_id, :year_of_study)
    end
end
