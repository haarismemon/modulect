module Admin
  class GroupsController < Admin::BaseController

    def show
      redirect_to edit_admin_group_path(params[:id])
    end

  	def index
  	end

  	def edit
      @group = Group.find(params[:id])
  	end

  	def update
      @group = Group.find(params[:id])
      if @group.update_attributes group_params
        flash[:success] = "#{@group.name} successfully updated."
        redirect_to edit_admin_year_structure_path(@group.year_structure)
      else
        render 'edit'
      end
  	end

  	def destroy
      @group = Group.find(params[:id])
      #store copy of the next redirect path before deletion of object
      redirect_path  = edit_admin_year_structure_path_path(@group.year_structure.id)
      #delete tuple object from db
      @group.destroy
      #to indicate success to user
      flash[:success] = @group.name+" has been deleted successfully."
      #redirect to action which displays parent year_structure
      redirect_back_or redirect_path
  	end

    private
    def group_params
      params.require(:group).permit(:name, :max_credits,:min_credits, :compulsory, uni_module_ids: [])
    end

  end
end
