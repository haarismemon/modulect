module Admin
  class UniModulesController < Admin::BaseController
  require 'will_paginate/array'


  	def index      

      @uni_modules = UniModule.all
    
      if params[:search].present?
        @uni_modules = @uni_modules.select { |uni_module| uni_module.name.downcase.include?(params[:search].downcase) }
        @uni_modules = @uni_modules.sort_by{|uni_module| uni_module[:name]}
      end
    

      # if sorting present
      if params[:search].present?
        @uni_modules = @uni_modules.paginate(page: params[:page], :per_page => 20)      
      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
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
