module Admin
  class UniModulesController < Admin::BaseController
    
        
  	def index
      @uni_modules = UniModule.paginate(page: params[:page], :per_page => 20).order('name ASC')
  	end

  	def new
      @uni_module = UniModule.new
  	end

    # For Feras
  	def create
  	end


    # For Feras
  	def edit
  	end


    # For Feras
  	def update

  	end

  	def destroy
      UniModule.find(params[:id]).destroy
      flash[:success] = "Module successfully deleted."
      redirect_to admin_uni_modules_path
  	end

  end
end
