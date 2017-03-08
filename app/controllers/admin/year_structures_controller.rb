module Admin
  class YearStructuresController < Admin::BaseController

  	def edit
      @year_structure = YearStructure.find(params[:id])
  	end

  	def update
      @year_structure = YearStructure.find(params[:id])
      if @year_structure.update_attributes year_structure_params
        flash[:notice] = "#{@year_structure.course.name} successfully updated."
        redirect_to admin_course_path(@year_structure.course)
      else
        render 'edit'
      end
  	end

    def year_structure_params
      params.require(:year_structure).permit(:year_of_study,
        groups_attributes: [:id, :name, :total_credits])
    end

  end
end
