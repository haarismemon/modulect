class UniModulesController < ApplicationController

  def index
    @uni_modules = UniModule.all
  end

  def show
    @uni_module = UniModule.find(params[:id])
  end

  def new
    @uni_module = UniModule.new
  end

  def create
    @uni_module = UniModule.new(uni_module_params)
    if @uni_module.save
      flash[:success] = "Module created"
      redirect_to(uni_modules_path)
    else
      flash[:danger] = @uni_module.errors.full_messages
      render('new')
    end
  end

  def edit
    @uni_module = UniModule.find(params[:id])
  end

  def update
    @uni_module = UniModule.find(params[:id])
    if @uni_module.update_attributes(uni_module_params)
      flash[:success] = "Module updated"
      redirect_to(uni_module_path(@uni_module))
    else
      flash[:danger] = @uni_module.errors.full_messages
      render('edit')
    end
  end

  def delete
    @uni_module = UniModule.find(params[:id])
  end

  def destroy
    @uni_module = UniModule.find(params[:id])
    @uni_module.destroy
    flash[:success] = "Module deleted"
    redirect_to(uni_modules_path)
  end


  private

  def uni_module_params
    params.require(:uni_module).permit(:name, :code, :description, :lecturers)
  end

end