module Admin
  class NoticesController < Admin::BaseController
    before_action :verify_correct_department, only: [:destroy, :update, :edit]
    def index
      @notices = Notice.all.where(department_id: @current_user.department_id)

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @notices = @notices.select { |notice| notice.title.downcase.include?(params[:search].downcase) }.sort_by{|notice| notice[:title]}
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @notices = sort(Notice, @notices, @sort_by, @order, @per_page, "title")
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)
      else
        @notices = @notices.order('title ASC').page(params[:page]).per(@per_page)
      end

    end

    def new
      # creates new notice
      @notice = Notice.new
    end

    def create
      # Instantiate a new object using form parameters
      @notice = Notice.new(user_params)
      # sets department id of notice to be the same as currently signed user
      @notice.department_id = @current_user.department_id
      # Save the object
      if @notice.save
        # If save succeeds, redirect to the index action
        flash[:success] = "The notice has successfuly been created "+@notice.broadcast ? "and is currently live." : ""
        redirect_to(admin_notices_path)
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

    def bulk_activate
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil?
            user.update_attribute("activated", "true")
          end
        
      end

      head :no_content
    end


    def bulk_deactivate
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            user.update_attribute("activated", "false")
          end
        
      end

      head :no_content
    end


    def bulk_delete
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            user.destroy
          end
        
      end

      head :no_content
    end

    def make_student_user
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            user.update_attribute("user_level", "user_access")
          end
        
      end

      head :no_content
    end

    def make_department_admin
        user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            user.update_attribute("user_level", "department_admin_access")
          end
        
      end

      head :no_content
    end

    def make_super_admin
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            user.update_attribute("user_level", "super_admin_access")
          end
        
      end

      head :no_content
    end

    def bulk_limit
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user.user_level == "user_access"
            user.update_attribute("is_limited", "true")
          end
        
      end

      head :no_content
    end

    def bulk_unlimit
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil?
            user.update_attribute("is_limited", "false")
          end
        
      end

      head :no_content
    end



    private

    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level, :faculty_id, :department_id, :course_id, :year_of_study, :activated, :is_limited)
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
