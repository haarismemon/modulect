module Admin
  class DepartmentsController < Admin::BaseController
    
     
  	def index      
      @departments = Department.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @departments = @departments.select { |department| department.name.downcase.include?(params[:search].downcase) }.sort_by{|department| department[:name]}.paginate(page: params[:page], :per_page => @per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @departments = sort(Department, @departments, @sort_by, @order, @per_page, "name")
      else
        @departments = @departments.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
      end

      respond_to do |format|
        format.html
        format.csv {send_data @departments.to_csv}
      end
    end

  	def new
  	end

  	def create
  	end

  	def edit
  	end

  	def update
  	end

  	def destroy
      @department = Department.find(params[:id])
      can_delete = true

      # check if being used
      UniModule.all.each do |uni_module|
        if uni_module.department_ids.include?(@department.id)
          can_delete = false
          break
        end
      end

      if can_delete
        # check if being used
        Course.all.each do |course|
          if course.department_ids.include?(@department.id)
            can_delete = false
            break
          end
        end
      end
      
      if can_delete
        @department.destroy
        flash[:success] = "Department successfully deleted"
        redirect_back_or admin_departments_path
      else 
        flash[:error] = "Department is linked to a course/module, unable to delete"
        redirect_back_or admin_departments_path
      end
  	end


  end
end
