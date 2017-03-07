module Admin
  class UniModulesController < Admin::BaseController
    
        
  	def index      
      @uni_modules = UniModule.all

      # if sorting present
      if params[:sortby].present? && params[:order].present?
        @uni_modules = sort(UniModule, @uni_modules, params[:sortby], params[:order], 20)
      else
        @uni_modules = @uni_modules.paginate(page: params[:page], :per_page => 20).order('name ASC')
      end

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
      @uni_module = UniModule.find(params[:id])
      can_delete = true

      # check if being used
      Group.all.each do |group|
        if group.uni_modules.include?(@uni_module)
          can_delete = false
          break
        end
      end

      if can_delete
        @uni_module.destroy
        flash[:success] = "Module successfully deleted"
        redirect_back_or admin_uni_modules_path
      else 
        flash[:error] = "Module is linked to a course, remove from course first"
        redirect_back_or admin_uni_modules_path
      end

  	end



  end
end
