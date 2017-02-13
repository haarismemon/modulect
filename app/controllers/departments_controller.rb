class DepartmentsController < ApplicationController
 
  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
    @department = Department.new  
  end

  def creare
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "Department created"
      redirect_to(departments_path)
    else
      flash[:danger] = @department.errors.full_messages
      render('new')
    end
  end

  def edit
    @department = Department.find(params[:id])
  end

  def update
    @department = Department.find(params[:id])
    if @department.update_attributes(department_params)
      flash[:success] = "Department updated"
      redirect_to(department_path(@department))
    else
      flash[:danger] = @department.errors.full_messages
      render('edit')
    end
  end

  def delete
    @department = Department.find(params[:id])
  end

  def destroy
    @department = Department.find(params[:id])
    @department.destroy
    flash[:success] = "Department deleted"
    redirect_to(departments_path)
  end

  private

  def department_params
    params.requite(:department).permit(:name)
  end

end