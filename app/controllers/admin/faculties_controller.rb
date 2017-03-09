module Admin
  class FacultiesController < Admin::BaseController
    
    
    def index      
      @faculties = Faculty.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        # find the correct modules,sort alphabetically and paginate
        @faculties = @faculties.select { |faculty| faculty.name.downcase.include?(params[:search].downcase) }.sort_by{|faculty| faculty[:name]}.paginate(page: params[:page], :per_page => @per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @faculties = sort(UniModule, @faculties, @sort_by, @order, @per_page)
      else
        @faculties = @faculties.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
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
        @faculty.destroy
        flash[:success] = "Faculty successfully deleted"
        redirect_back_or admin_faculties_path
      else 
        flash[:error] = "Faculty contains departments, can't delete"
        redirect_back_or admin_faculties_path
      end
    end

    def add_new_faculty
      new_faculty = Faculty.find_by_name(params[:faculty_name])

      if new_faculty.nil?
        new_faculty = Faculty.create(name: params[:faculty_name])

        unless params[:department_id].nil?
          department = Department.find(params[:department_id])
          unless department.nil?
            department.faculty = new_faculty
          end
        end

      end

      head :no_content
    end


  end
end
