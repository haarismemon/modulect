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

        @departments = @uni_module.department_ids.pluck(:name)
        @careerTags = @uni_module.career_tags.pluck(:name)
        @interestTags = @uni_module.interest_tags.pluck(:name)
      end
  	end

  	def update
      @uni_module = UniModule.find(params[:id])

      #Update the module with the new attributes
      if @uni_module.update_attributes(uni_module_params)
        # Successfully updated
        flash[:success] = "Successfully updated #{@uni_module.name}"
        redirect_to(@uni_module) and return
      else
        # Failed to update
        # If save fails, redisplay the form so user can fix problems
        render('admin/uni_module/edit')
      end
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

    private
    def uni_module_params
      params.require(:uni_module).permit(:name, :code, :description, :semester, :credits, :lecturers, :assessment_methods, :exam_percentage, :coursework_percentage, :pass_rate, :more_info_link)
    end

  end
end
