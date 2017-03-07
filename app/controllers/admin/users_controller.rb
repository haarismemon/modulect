module Admin
  class UsersController < Admin::BaseController
    def new
      @user = User.new
    end

    def create
      # Instantiate a new object using form parameters
      @user = User.new(user_params)
      # add faculty value inferred from department
      automatic_faculty_update
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
      # add faculty value inferred from department
      automatic_faculty_update
      # Update the object
      if @user.update_attributes(user_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @user.full_name
        redirect_to(admin_users_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/users/edit')
      end
    end

    def destroy
      #find by id
      @user = User.find(params[:id])
      
      if @user.user_level == "super_admin_access"
        flash[:error] = "For security, super admins cannot be deleted through Modulect. Please use the database instead."
        redirect_to(admin_users_path)
      else
        #delete tuple object from db
        @user.destroy
        flash[:success] = @user.full_name+" has been deleted successfully."
        #redirect to action which displays all users
        redirect_to(admin_users_path)
      end

    end

    def show
      @user = User.find(params[:id])
    end



    def index
      #returns all users by order of last_name
     @users = User.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @users = @users.select { |user| user.first_name.downcase.include?(params[:search].downcase) || user.last_name.downcase.include?(params[:search].downcase) }.sort_by{|user| user[:first_name]}.paginate(page: params[:page], :per_page => @per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @users = sort(User, @users, @sort_by, @order, @per_page, "first_name")
      else
        @users = @users.paginate(page: params[:page], :per_page => @per_page).order('first_name ASC')
      end

    end

    private

    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end

    # Infers users faculty from department
    def automatic_faculty_update
      if(@user.department.present?)
        @user.faculty = @user.department.faculty
      end
    end

  end
end