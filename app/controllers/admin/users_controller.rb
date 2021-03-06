module Admin
  class UsersController < Admin::BaseController
    before_action :verify_correct_department, only: [:destroy, :update, :edit]
    
    # the customised advanced index action handles the displaying of the correct records for the user level, the pagination, the search and the sorting by the columns specified in the view
    def index
      # show correct records based on user level
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
      
      # if user has changed per_page, change it else use the default of 20
      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      # if the user is searching look for records which match the search query and paginate accordingly      
      if params[:search].present?
        @search_query = params[:search]
        @users = @users.select { |user| user.first_name.downcase.include?(params[:search].downcase) || user.last_name.downcase.include?(params[:search].downcase) }.sort_by{|user| user[:first_name]}
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)

      # if the user wasn't search but was sorting get the records and sort accordingly
      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @users = sort(User, @users, @sort_by, @order, @per_page, "first_name")
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)
      else
        @users = @users.sort_by{|user| user[:first_name].downcase}
        @users = Kaminari.paginate_array(@users).page(params[:page]).per(@per_page)
      end

      if @users.size == 0 && params[:page].present? && params[:page] != "1"
        redirect_to admin_users_path
      end
     
      # handles the csv uploads
      @users_to_export = @users
      if params[:export].present?
        export_user_ids_string = params[:export]
        export_user_ids = eval(export_user_ids_string)

        if current_user.user_level == "department_admin_access"
          department_user_ids = Department.find(current_user.department_id).user_ids
          export_module_ids = export_module_ids & department_user_ids.map(&:to_s)
        end

        @users_to_export = User.where(id: export_user_ids)
        @users_to_export = @users_to_export.order('LOWER(first_name) ASC')  
      else
        @users_to_export = @users
      end

      respond_to do |format|
        format.html
        format.csv {send_data @users_to_export.to_csv}
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
        flash[:success] = "Successfully created #{@user.full_name} with the correct access levels"
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
        flash[:error] = "For security, there must always be at least one super/system administrator."
        redirect_to(edit_admin_user_path) and return
        # if a department admin tries to delete all the department admins, then this stops them. a super admin can do as they please
      elsif current_user.user_level != "super_admin_access" && @user.user_level == "department_admin_access" && user_params[:user_level] != "department_admin_access" && get_num_dept_admins(current_user.department_id) == 1
        flash[:error] = "There must be at least one Department Administrator."
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
        flash[:error] = "For security, there must always be at least one super/system administrator."
        redirect_to(admin_users_path)
      elsif current_user.user_level != "super_admin_access" && @user.user_level == "department_admin_access" && @user.user_level == "department_admin_access" && get_num_dept_admins(current_user.department_id) == 1
        flash[:error] = "There must be at least one Department Admin"
        redirect_to(edit_admin_user_path) and return
      else
        #delete tuple object from db

        SavedModule.where(user_id: @user.id).destroy_all
        Pathway.where(user_id: @user.id).destroy_all
        @user.destroy
        flash[:success] = "Successfully deleted " + @user.full_name
        #redirect to action which displays all users
        redirect_to(admin_users_path)
      end

    end

    # handles bulk activation action
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

    # handles bulk deactivation action
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

    # handles bulk deletion action
    def bulk_delete
      user_ids_string = params[:ids]
      user_ids = eval(user_ids_string)

      user_ids.each do |id|
        user = User.find(id.to_i)
        
          if !user.nil? && user != current_user
            SavedModule.where(user_id: user.id).destroy_all
            Pathway.where(user_id: user.id).destroy_all
            user.destroy
          end
        
      end

      head :no_content
    end

    # handles downgrade of user level
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

    # handles a change in user level
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

    # handles a change in user level
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

    # handles the bulk limiting of users action
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

    # handles bulk unlimiting of users
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
