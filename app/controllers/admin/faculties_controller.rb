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
          @faculties = @faculties.select { |faculty| faculty.name.downcase.include?(params[:search].downcase) }.sort_by{|faculty| faculty[:name]}.paginate(page: params[:page], :per_page => @per_page) 

        elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
          @sort_by = params[:sortby]
          @order = params[:order]
          @faculties = sort(Faculty, @faculties, @sort_by, @order, @per_page, "name")
        else
          @faculties = @faculties.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
        end

      end

      def new
        @faculty = Faculty.new
      end

      def create
        @faculty = Faculty.new(faculty_params)
        if @faculty.save
          # If save succeeds, redirect to the index action
          flash[:notice] = "Succesfully created faculty"
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
          @faculty.destroy
          flash[:success] = "Faculty successfully deleted"
          redirect_to admin_faculties_path
        else 
          flash[:error] = "Faculty contains departments, can't delete"
          redirect_to admin_faculties_path
        end
      end



    private

      def faculty_params
        #!add params that want to be recognized by this application
        params.require(:faculty).permit(:name)
      end


    end


end
