module Admin
  class YearStructuresController < Admin::BaseController
    before_action :check_valid_update, only: [:update]

    # Handles controller for a year structure which is used within a course
    # Most of the code is self-explanatory

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
        redirect_to admin_year_structure_path(@year_structure)
      else
        @year_structure.reload
        render 'edit'
      end
    end

    private
    # checks that the update made was valid, and if not redirects and produces a warning in the index
    def check_valid_update
      if params[:year_structure].nil?
        flash_message = "No module group was added. "
        flash_message += "Please try adding a module group or editing existing ones before updating."
        flash[:error] = flash_message
        redirect_to edit_admin_year_structure_path(params[:id]) 
        return
      end
    end

    def year_structure_params
      params.require(:year_structure).permit(:year_of_study, :year_credits,
        groups_attributes: [:id, :name, :max_credits, :min_credits, :compulsory, uni_module_ids: []])
    end
  end
end
