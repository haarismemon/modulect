class YearStructuresController < ApplicationController

  def index
    @year_structures = YearStructure.alphabetically_order_by('year_of_study')
  end

  def new
    @year_structure = YearStructure.new
  end

  def edit
    #! looks for object to populate form with the associated structure's data ready for modification by admin
    @tag = Tag.find(params[:id])
  end

  def create
    @year_structure = YearStructure.new(year_structure_params)
    # Save the object
    if @year_structure.save
      # If save succeeds, redirect to the index action
      flash[:notice] = " Year #{@year_structure.year_of_study} was created successfully."
      redirect_to(year_structures_path)
    else
      # If save fails, redisplay the form so admin can fix problems
      render('new')
    end
  end


  def update
    # Find a new object using form parameters
    @year_structures = YearStructure.find(params[:id])
    # Update the object
    if @year_structures.update_attributes(tags_params)
      # If save succeeds, redirect to the show action
      flash[:notice] = "Year #{@year_structure.year_of_study} was updated successfully."
      redirect_to(year_structures_path)
    else
      # If save fails, redisplay the form so admin can fix problems
      render('edit')
    end
  end

  def destroy
    #find by id
    @year_structure = YearStructure.find(params[:id])
    #delete tuple object from db
    @year_structure.destroy
    flash[:notice] =  "Year #{@year_structure.year_of_study} was deleted successfully."
    #redirect to action which displays all year structures
    redirect_to(@year_structures_path)
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def year_structure_params
      params.require(:year_structure).permit(:year_of_study, :created_at)
    end
end
