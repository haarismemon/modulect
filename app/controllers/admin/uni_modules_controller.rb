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
        @uni_modules = sort(UniModule, @uni_modules, @sort_by, @order, @per_page, "name")
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
      end

  	end

  

  def bulk_delete
    module_ids_string = params[:ids]
    module_ids = eval(module_ids_string)

    module_ids.each do |id|
      uni_module = UniModule.find(id.to_i)

      if !uni_module.nil?
        uni_module.update_attribute("name", "AB")
      end
    end



  end

end
 
end
