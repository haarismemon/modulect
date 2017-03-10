module Admin
  class DepartmentsController < Admin::BaseController
    before_action :verify_super_admin, only: [:destroy, :new, :create, :update, :edit, :index,]
     
  	def index      

      if params[:faculty].present? && params[:faculty].to_i != 0 && Faculty.exists?(params[:faculty].to_i)
          @faculty_filter_id = params[:faculty].to_i
          @departments = Faculty.find(@faculty_filter_id).departments
        else
          @departments = Department.all 
        end

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @departments = @departments.select { |department| department.name.downcase.include?(params[:search].downcase) }.sort_by{|department| department[:name]}
        @departments = Kaminari.paginate_array(@departments).page(params[:page]).per(@per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @departments = sort(Department, @departments, @sort_by, @order, @per_page, "name")
        @departments = Kaminari.paginate_array(@departments).page(params[:page]).per(@per_page)

      else
         @departments = @departments.order('name ASC').page(params[:page]).per(@per_page)
      end

    end

    def new
      @department = Department.new
    end

    def create
      # Instantiate a new object using form parameters
      @department = Department.new(department_params)
      # Save the object
      if @department.save
        # If save succeeds, redirect to the index action
        flash[:notice] = "You have successfully created #{@department.name}"
        redirect_to(admin_departments_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render("admin/departments/new")

      end
    end

    def edit
      #! allows for template's form to be ready populated with the associated users data ready for modification by admin
      @department = Department.find(params[:id])
    end

    def update
      # Find a  object using id parameters
      @department = Department.find(params[:id])
      # Update the object
      if @department.update_attributes(department_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @department.name
        redirect_to(admin_departments_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/departments/edit')
      end
    end

  	def destroy
      @department = Department.find(params[:id])
      # check for constraints
      if has_no_course_dependacies && has_no_uni_module_dependacies
        #delete tuple object from db
        @department.destroy
        flash[:success] = @department.name+" has been deleted successfully."
      else
        flash[:error] = @department.name+" is linked to a course/module, first either move or delete those modules."
      end
      #redirect to action which displays all departments
      redirect_back_or admin_departments_path
    end

    private

    def department_params
      #!add params that want to be recognized by this application
      params.require(:department).permit(:faculty_id,:name,:course_ids=>[])
    end

      # checks no uni module is linked to it already
      def has_no_uni_module_dependacies
        @department.uni_modules.empty??true:false
      end


      # checks no course is linked to it already
    def has_no_course_dependacies
      @department.courses.empty??true:false
    end

    def verify_super_admin
       redirect_to admin_path unless current_user.user_level == "super_admin_access"

    end



  end
end
