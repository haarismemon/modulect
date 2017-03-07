module Admin
  class UniModulesController < Admin::BaseController
  require 'will_paginate/array'


  	def index      
      @uni_modules = UniModule.all 

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        # find the correct modules,sort alphabetically and paginate
        @uni_modules = @uni_modules.select { |uni_module| uni_module.name.downcase.include?(params[:search].downcase) }.sort_by{|uni_module| uni_module[:name]}.paginate(page: params[:page], :per_page => @per_page) 

        if @uni_modules.size == 0
          @uni_modules = UniModule.all.select { |uni_module| uni_module.code.downcase.include?(params[:search].downcase) }.sort_by{|uni_module| uni_module[:code]}.paginate(page: params[:page], :per_page => @per_page)
        end 

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @uni_modules = sort(UniModule, @uni_modules, @sort_by, @order, @per_page)
      else
        @uni_modules = @uni_modules.paginate(page: params[:page], :per_page => @per_page).order('name ASC')
      end

  	end

  	def new
      @uni_module = UniModule.new
  	end

    # For Feras
  	def create
  	end


  	def edit
      if params[:id].present?
        @uni_module = UniModule.find(params[:id])
      end
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
