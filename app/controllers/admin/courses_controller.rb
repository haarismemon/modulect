module Admin
  class CoursesController < Admin::BaseController


      
    def index 
      if current_user.user_level == "super_admin_access"     
        @courses = Course.all
      else
        @courses = Department.find(current_user.department_id).courses
      end

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @courses = @courses.select { |course| course.name.downcase.include?(params[:search].downcase) }.sort_by{|course| course[:name]}.paginate(page: params[:page], :per_page => @per_page) 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @courses = sort(Course, @courses, @sort_by, @order, @per_page, "name")
      else
        @courses = @courses.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
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
    end

 


  end
end