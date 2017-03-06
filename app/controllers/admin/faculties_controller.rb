module Admin
  class FacultiesController < Admin::BaseController
   
    # must paginate
  	def index
      @faculties = Faculty.all
  	end

  	def new
      @faculty = Faculty.new
  	end

  	def create
    @faculty = Faculty.new(user_params)
    if @faculty.save
      flash[:info] = "Faculty succesffully created"
      redirect_to admin_edit_faculty_path(@faculty)
    else
      render 'new'
    end
  end

  	def edit
  	end

  	def update
      if @user.update_attributes(user_params)
        flash[:success] = "Faculty updated"
      redirect_to admin_edit_faculty_path(@faculty)
      else
        render 'edit'
      end
  	end

  	def destroy
       Faculty.find(params[:id]).destroy
        flash[:success] = "Faculty deleted"
        redirect_to admin_faculties_path
  	end


    private
    
    def faculty_params
      params.require(:faculty).permit(:name)
    end


  end
end
