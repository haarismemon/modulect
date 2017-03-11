module Admin
  class UniModulesController < Admin::BaseController
#  require 'will_paginate/array'


  	def index

      if current_user.user_level == "super_admin_access"     
        if params[:dept].present? && params[:dept].to_i != 0 && Department.exists?(params[:dept].to_i)
          @dept_filter_id = params[:dept].to_i
          @uni_modules = Department.find(@dept_filter_id).uni_modules
        else
          @uni_modules = UniModule.all 
        end
      else
        @uni_modules = Department.find(current_user.department_id).uni_modules
      end  

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        # find the correct modules,sort alphabetically and paginate
        @uni_modules = @uni_modules.select { |uni_module| uni_module.name.downcase.include?(params[:search].downcase) }.sort_by{|uni_module| uni_module[:name]}

        # perhaps they were looking for a code
        if @uni_modules.size == 0
          @uni_modules = UniModule.all.select { |uni_module| uni_module.code.downcase.include?(params[:search].downcase) }.sort_by{|uni_module| uni_module[:name]}
        end 
        @uni_modules = Kaminari.paginate_array(@uni_modules).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @uni_modules = sort(UniModule, @uni_modules, @sort_by, @order, @per_page, "name")
       @uni_modules = Kaminari.paginate_array(@uni_modules).page(params[:page]).per(@per_page)


      else
        @uni_modules = @uni_modules.order('LOWER(name) ASC').page(params[:page]).per(@per_page)
      end




      @uni_modules_to_export = @uni_modules
      if params[:export].present?
        export_module_ids_string = params[:export]
        export_module_ids = eval(export_module_ids_string)
        @uni_modules_to_export = UniModule.where(id: export_module_ids)  
      else
        @uni_modules_to_export = @uni_modules
      end

      respond_to do |format|
        format.html
        format.csv {send_data @uni_modules_to_export.to_csv}
      end




  	end

  	def new
      @uni_module = UniModule.new

        @departments = []
        @careerTags = []
        @interestTags = []
  	end

  	def create
      @uni_module = UniModule.new(uni_module_params)
      if @uni_module.save
        # If save succeeds, redirect to the index action
        flash[:notice] = "Succesfully created module"
        redirect_to(admin_uni_modules_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render(:new)
      end
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
        redirect_to(edit_admin_uni_module_path(@uni_module)) and return
      else
        # Failed to update
        # If save fails, redisplay the form so user can fix problems
        render(edit_admin_uni_module_path(uni_module))
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

  def bulk_delete
    module_ids_string = params[:ids]
    module_ids = eval(module_ids_string)

    module_ids.each do |id|
      uni_module = UniModule.find(id.to_i)
      can_delete = true
      if !uni_module.nil?

        Group.all.each do |group|
          if group.uni_modules.include?(uni_module)
            can_delete = false
            break
          end
        end
        if can_delete
         uni_module.destroy
        end

      end
      #uni_module.update_attribute("name", id)

    end

    head :no_content

  end


   private
    def uni_module_params
      params.require(:uni_module).permit(:name, :code, :description, :semester, :credits, :lecturers, :assessment_methods, :exam_percentage, :coursework_percentage, :pass_rate, :more_info_link)
    end

end
 
end
