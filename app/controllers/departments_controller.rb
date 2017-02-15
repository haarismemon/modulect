class DepartmentsController < ApplicationController
 
  def index
    #returns all departments by order of name
    @departments = Department.alphabetically_order_by("name")
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new  
  end

  def create
    @department = Department.new(tags_params)
    # Save the object
    if @department.save
      # If save succeeds, redirect to the index action
      flash[:notice] = @department.name+" was created successfully."
      redirect_to(departments_path)
    else
      # If save fails, redisplay the form so user can fix problems
      render('new')
    end
  end

  def edit
    #! looks for object to ready populate form with the associated department's data ready for modification by admin
    @department = Department.find(params[:id])
  end

  def update
    # Find a new object using form parameters
    @department = Department.find(params[:id])
    # Update the object
    if @department.update_attributes(department_params)
      # If save succeeds, redirect to the show action
      flash[:notice] = @department.name+" was updated successfully."
      redirect_to(department_path(@department))
    else
      # If save fails, redisplay the form so user can fix problems
      render('edit')
    end
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:notice] =  @department.name+"was deleted successfully."
    redirect_to(departments_path)
  end

  private

  def department_params
    params.require(:department).permit(:name)
  end

end