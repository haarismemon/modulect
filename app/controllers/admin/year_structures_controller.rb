module Admin
  class YearStructuresController < Admin::BaseController
    before_action :check_valid_update, only: [:update]

    def show
      redirect_to edit_admin_year_structure_path(params[:id])
    end
    
  	def edit
      @year_structure = YearStructure.find(params[:id])
  	end

  	def update
      @year_structure = YearStructure.find(params[:id])
      if @year_structure.update_attributes year_structure_params
        flash[:success] = "Successfully updated."
        redirect_to admin_course_path(@year_structure.course)
      else
        render 'edit'
      end
    end

    private
    def check_valid_update
      if params[:year_structure].nil?
        flash_message = "No module group was added. "
        flash_message += "Please try adding a module group or editing existing ones."
        flash[:error] = flash_message
        redirect_to edit_admin_year_structure_path(params[:id]) 
        return
      end
    end

    def year_structure_params
      params.require(:year_structure).permit(:year_of_study,
        groups_attributes: [:id, :name, :max_credits,:min_credits, :compulsory, uni_module_ids: []])
    end
  end
end
