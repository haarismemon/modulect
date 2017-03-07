module Admin
  class UsersController < ApplicationController
    layout 'admin/application'

    def new
      @users = User.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @users = @users.select { |user| user.first_name.downcase.include?(params[:search].downcase) }.sort_by{|user| user[:first_name]}.paginate(page: params[:page], :per_page => @per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @users = sort(User, @users, @sort_by, @order, @per_page)
      else
        @users = @users.paginate(page: params[:page], :per_page => @per_page).order('first_name ASC')
      end

    end

    def create
      # Instantiate a new object using form parameters
      @user = User.new(user_params)
      # Save the object
      if @user.save
        # If save succeeds, redirect to the index action
        flash[:notice] = "You have successfully created #{@user.full_name} and it's privileges have been granted"
        redirect_to(admin_users_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render(:new)

      end
    end


    def edit
      #! allows for template's form to be ready populated with the associated users data ready for modification by admin
      @user = User.find(params[:id])
    end

    def update
      # Find a  object using id parameters
      @user = User.find(params[:id])
      # Update the object
      if @user.update_attributes(admin_user_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @user.full_name
        redirect_to(admin_user_path(@user)) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('edit')
      end
    end

    def destroy
      #find by id
      @user = User.find(params[:id])
      #delete tuple object from db
      @user.destroy
      flash[:success] = @user.full_name+" has been deleted successfully."
      #redirect to action which displays all users
      redirect_to(admin_users_path)
    end

    def show
      @user = User.find(params[:id])
    end



    def index
      #returns all users by order of last_name
      @users = User.paginate(:page => params[:page])
    end

    private

    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end

  end
end