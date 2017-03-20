module Admin
  class FacultiesController < Admin::BaseController
    before_action :verify_super_admin, only: [:destroy, :new, :create, :update, :edit, :index,]
      
    def show
      redirect_to edit_admin_department_path(params[:id])
    end
 
    def index      
      @faculties = Faculty.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @faculties = @faculties.select { |faculty| faculty.name.downcase.include?(params[:search].downcase) }.sort_by{|faculty| faculty[:name]}
        @faculties = Kaminari.paginate_array(@faculties).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @faculties = sort(Faculty, @faculties, @sort_by, @order, @per_page, "name")
        @faculties = Kaminari.paginate_array(@faculties).page(params[:page]).per(@per_page)
      else
       @faculties = @faculties.order('name ASC').page(params[:page]).per(@per_page)
      end

      if @faculties.size == 0 && params[:page].present? && params[:page] != "1"
        redirect_to admin_faculties_path
      end

     
      if current_user.user_level == "super_admin_access"

        @faculties_to_export = @faculties
        if params[:export].present?
          export_faculties_ids_string = params[:export]
          export_faculties_ids = eval(export_faculties_ids_string)

          @faculties_to_export = Faculty.where(id: export_faculties_ids)
          @faculties_to_export = @faculties_to_export.order('LOWER(name) ASC')  
        else
          @faculties_to_export = @faculties
        end


          respond_to do |format|
            format.html
            format.csv {send_data @faculties_to_export.to_csv}
          end

      end

   




    end

    def new
      @faculty = Faculty.new
    end

    def create
      @faculty = Faculty.new(faculty_params)
      if @faculty.save
        # If save succeeds, redirect to the index action
        flash[:success] = "Succesfully created faculty"
        redirect_to(admin_faculties_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render(:new)
      end
    end

    def edit
      @faculty = Faculty.find(params[:id])
    end

    def update
      @faculty = Faculty.find(params[:id])
      # Update the object
      if @faculty.update_attributes(faculty_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @faculty.name
        redirect_to(edit_admin_faculty_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/faculty/new')
      end
    end

    def destroy
      @faculty = Faculty.find(params[:id])
      can_delete = true

      # check if being used
      Department.all.each do |department|
        if department.faculty_id == @faculty.id
          can_delete = false
          break
        end
      end
      
      if can_delete
        @faculty.users.each do |user|
          user.update_attribute("faculty_id", nil)
        end
        @faculty.destroy
        flash[:success] = "Faculty successfully deleted"
        redirect_to admin_faculties_path
      else 
        flash[:error] = "Faculty contains departments, can't delete"
        redirect_to admin_faculties_path
      end
    end

    def add_new_faculty
      new_faculty = Faculty.find_by_name(params[:faculty_name])

      if new_faculty.nil?
        new_faculty = Faculty.create(name: params[:faculty_name])

        unless params[:department_id].nil? || params[:current_department_id] == -1
          department = Department.find(params[:current_department_id])
          unless department.nil?
            department.faculty = new_faculty
          end
        end

      end

      data = {new_faculty_id: new_faculty.id}
      render json: data
    end

    def bulk_delete
      faculties_ids_string = params[:ids]
      faculty_ids = eval(faculties_ids_string)

      faculty_ids.each do |id|
        faculty = Faculty.find(id.to_i)
              
         if !faculty.nil? && faculty.departments.empty?
            faculty.users.each do |user|
              user.update_attribute("faculty_id", nil)
            end
           faculty.destroy
         end
              
       end

       head :no_content
    end

    def clone
     faculties_ids_string = params[:ids]
      faculty_ids = eval(faculties_ids_string)

      faculty_ids.each do |id|
        faculty = Faculty.find(id.to_i)
        
          if !faculty.nil?
            if Faculty.exists?(name: faculty.name + "-CLONE")
              flash[:error] = "Some records have already been cloned and cannot be recloned."
            else
              cloned = faculty.dup
              cloned.update_attribute("name", cloned.name + "-CLONE")
            end
          end
        
      end

      head :no_content
    end


  private

    def faculty_params
      #!add params that want to be recognized by this application
      params.require(:faculty).permit(:name, :department_ids=>[])
    end
    
    def verify_super_admin
     redirect_to admin_path unless current_user.user_level == "super_admin_access"

    end


  end

end
