class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  skip_before_action :store_location,
                      only: [:new, :edit]
  protect_from_forgery except: [:update_departments, :update_courses]
  before_action :registration_allowed, only: [:new, :create]

  include ApplicationHelper

  def index
    #returns all users by order of last_name
    #@users = User.alphabetically_order_by(:last_name)
  end

  def show
    redirect_to(edit_user_path)
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
      flash[:success] = "You have successfully created user: #{@user.full_name} and their privileges have been granted"
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
      flash[:success] = "Please check your email to activate your account or contact an administrator."
    else
      render 'new'
    end
  end

  def edit
    #! allows for template's form to be ready populated with the associated users data ready for modification by admin
    @user = User.find(params[:id])

    # for debugging the reset
    #@user.update_attributes("year_of_study" => 0, "faculty_id" =>1,  "department_id" => 1,  "course_id" => 1)

    # Get arrays to use for profiles
    @faculties = Faculty.all
    #Initialise departments and courses to be empty unless previously selected
    if(@user.department_id.present?)
      @departments = Faculty.find_by_id(@user.faculty_id).departments
    else
      @departments = {}
    end
    if(@user.department_id.present? && @user.course_id.present?)
      @courses = Department.find_by_id(@user.department_id).courses
    else
      @courses = {}
    end
    if(@user.department_id.present?)
        @all_courses = Department.find_by_id(@user.department_id).courses
     end
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
    @task = params[:task]

    if @task == "reset"
       @user.reset
       flash[:success] = "You have successfully reset your account."
       redirect_to(edit_user_path)
    else
      if @user.update_attributes(update_params)
        flash[:success] = "Successfully updated your account."
        if params.has_key?(:dest) && !params[:dest].empty?
          redirect_to params[:dest] + "?year=" + @user.year_of_study.to_s  + "&course=" + @user.course_id.to_s
        else
          redirect_to(edit_user_path)
        end
      else
        flash[:error] = "Please check that you have entered your details correctly and try again."
        render 'edit'
      end
    end
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

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # checks whether registration has been disabled by a super admin
  def registration_allowed
    if !app_settings.allow_new_registration
      flash[:error] = "Registration is currently offline, please check back later."
       redirect_to(root_url)
    end
  end

end
