module Admin
  class UsersController < Admin::BaseController
    before_action :verify_correct_department, only: [:destroy, :update, :edit]


    def index

      if current_user.user_level == "super_admin_access"
        if params[:dept].present? && params[:dept].to_i != 0 && Department.exists?(params[:dept].to_i)
          @dept_filter_id = params[:dept].to_i
          @users = User.select{|user| user.department_id == params[:dept].to_i && user.user_level != "super_admin_access"}
        else
          @users = User.all
        end
      else
       # @users = User.select{|user| user.department_id == current_user.department_id && user.user_level != "super_admin_access"}
        @users = User.where("department_id = ? AND (user_level = ? OR user_level = ?)", current_user.department_id, "2", "3")
      end

      respond_to do |format|
        format.html
        format.csv {send_data @users.to_csv}
      end

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @users = @users.select { |user| user.first_name.downcase.include?(params[:search].downcase) || user.last_name.downcase.include?(params[:search].downcase) }.sort_by{|user| user[:first_name]}
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @users = sort(User, @users, @sort_by, @order, @per_page, "first_name")
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)
      else
        @users = @users.sort_by{|user| user[:first_name].downcase}
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)
      end

    end

    def new
      @user = User.new
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
    end

    def create
      # Instantiate a new object using form parameters
      @user = User.new(user_params)
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
      # Save the object
      if @user.save
        # If save succeeds, redirect to the index action
        flash[:notice] = "You have successfully created #{@user.full_name} and their privileges have been granted"
        redirect_to(admin_users_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render("admin/users/new")

      end
    end


    def edit
      #! allows for template's form to be ready populated with the associated users data ready for modification by admin
      @user = User.find(params[:id])
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
      # Find a  object using id parameters
      @user = User.find(params[:id])

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

      # if a request to a super admin requested, check that there will still be at least one super admin left by checking the incoming user level parameter
      if @user.user_level == "super_admin_access" && user_params[:user_level] != "super_admin_access" && get_num_super_admins == 1
        flash[:error] = "For security, there must always be at least one super/system administrator"
        redirect_to(edit_admin_user_path) and return
        # if a department admin tries to delete all the department admins, then this stops them. a super admin can do as they please
      elsif current_user.user_level != "super_admin_access" && @user.user_level == "department_admin_access" && user_params[:user_level] != "department_admin_access" && get_num_dept_admins(current_user.department_id) == 1
        flash[:error] = "There must be at least one Department Admin"
        redirect_to(edit_admin_user_path) and return
      else
        # Update the object
        if @user.update_attributes(user_params)
          # If save succeeds, redirect to the index action
          flash[:success] = "Successfully updated "+ @user.full_name
          redirect_to(edit_admin_user_path) and return
        else
          # If save fails, redisplay the form so user can fix problems
          render('admin/users/edit')
        end
      end
    end


    def destroy
      #find by id
      @user = User.find(params[:id])

      if @user.user_level == "super_admin_access" && get_num_super_admins == 1
        flash[:error] = "For security, there must always be at least one super/system administrator"
        redirect_to(admin_users_path)
      elsif current_user.user_level != "super_admin_access" && @user.user_level == "department_admin_access" && @user.user_level == "department_admin_access" && get_num_dept_admins(current_user.department_id) == 1
        flash[:error] = "There must be at least one Department Admin"
        redirect_to(edit_admin_user_path) and return
      else
        #delete tuple object from db
        @user.destroy
        flash[:success] = @user.full_name+" has been deleted successfully."
        #redirect to action which displays all users
        redirect_to(admin_users_path)
      end

    end

    def bulk_deactivate
    end


    def bulk_deactivate
    end


    def bulk_delete
    end

    def make_student_user
    end

    def make_department_admin
    end

    def make_super_admin
    end


    private

    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level, :faculty_id, :department_id, :course_id, :year_of_study, :activated)
    end

    def get_num_super_admins
      super_admins = User.all.select { |user| user.user_level == "super_admin_access" }
      super_admins.size
    end

    def get_num_dept_admins(department_id)
      department_admins = User.all.select { |user| user.user_level == "department_admin_access" && user.department_id == department_id }
      department_admins.size
    end

    def verify_correct_department
      @user = User.find(params[:id])
      redirect_to admin_path unless (current_user.department_id == @user.department_id && @user.user_level != "super_admin_access") || current_user.user_level == "super_admin_access"

    end


  end
end