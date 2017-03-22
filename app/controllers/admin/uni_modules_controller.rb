module Admin
  class UniModulesController < Admin::BaseController
    before_action :verify_correct_department, only: [:update, :edit, :destroy, :comments]

    def show
      redirect_to edit_admin_uni_module_path(params[:id])
    end

    # the customised advanced index action handles the displaying of the correct records for the user level, the pagination, the search and the sorting by the columns specified in the view
    def index
      # show correct records based on user level
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

      # if user has changed per_page, change it else use the default of 20
      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end
      
      # if the user is searching look for records which match the search query and paginate accordingly
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

      # if the user wasn't search but was sorting get the records and sort accordingly
      else
        @uni_modules = @uni_modules.order('LOWER(name) ASC').page(params[:page]).per(@per_page)
      end

      if @uni_modules.size == 0 && params[:page].present? && params[:page] != "1"
        redirect_to admin_uni_modules_path
      end
     
      # handles the csv uploads
      @uni_modules_to_export = @uni_modules
      if params[:export].present?
        export_module_ids_string = params[:export]
        export_module_ids = eval(export_module_ids_string)

        if current_user.user_level == "department_admin_access"
          department_uni_module_ids = Department.find(current_user.department_id).uni_module_ids
          export_module_ids = export_module_ids & department_uni_module_ids.map(&:to_s)
        end

        @uni_modules_to_export = UniModule.where(id: export_module_ids)
        @uni_modules_to_export = @uni_modules_to_export.order('LOWER(name) ASC')
      
      # default record view
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
      @required = []
    end

    def create
      @uni_module = UniModule.new(uni_module_params)
      if params[:uni_module][:career_tags].present? && !params[:uni_module][:career_tags].empty? && params[:uni_module][:interest_tags].present? && !params[:uni_module][:interest_tags].empty? && params[:uni_module][:department_ids].present? && !params[:uni_module][:department_ids].empty?

        departments = params[:uni_module][:department_ids].split(',')
        required = params[:uni_module][:required].split(',')
        career_tags = params[:uni_module][:career_tags].split(',')
        interest_tags = params[:uni_module][:interest_tags].split(',')

        @uni_module.departments.clear()
        if current_user.user_level == "department_admin_access"
          user_dept = Department.find(current_user.department_id).name
          if !(departments.include? user_dept)
            # If user does not include their own department in the department list.
            @uni_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
            @departments = departments
            @careerTags = career_tags
            @interestTags = interest_tags
            @required = required
            # Redisplay the form so user can fix problems
            ## THIS RENDER IS CAUSING PROBLEMS - FORM IS NOT RESUBMITTING
            render("admin/uni_modules/new") and return
          end
        end
        departments.each do |dept|
          chosen_dept = Department.find_by_name(dept)
          @uni_module.departments << chosen_dept
        end

        @uni_module.uni_modules.clear()
        required.each do |mod|
          chosen_mod = UniModule.find_by_name(mod)
          @uni_module.uni_modules << chosen_mod
        end

        @uni_module.tags.clear()

        career_tags.each do |tag|
          chosen_tag = Tag.find_by_name(tag)
          # Add the career tag association
          if chosen_tag.present?
            @uni_module.tags << chosen_tag
          else
            # If tag does not already exist then create a new tag
            new_tag = Tag.new(name: tag, type: "CareerTag")
            @uni_module.tags << new_tag
          end
        end

        interest_tags.each do |tag|
          chosen_tag = Tag.find_by_name(tag)
           # Add the interest tag association
          if chosen_tag.present?
            @uni_module.tags << chosen_tag
          else
            # If tag does not already exist then create a new tag
            new_tag = Tag.new(name: tag, type: "InterestTag")
            @uni_module.tags << new_tag
          end
        end

        if @uni_module.save
          # If save succeeds, redirect to the index action
          flash[:success] = "Succesfully created module"
          redirect_to(admin_uni_modules_path)
        else
          # If save fails, redisplay the form so user can fix problems
          if !params[:uni_module][:department_ids].present? || params[:uni_module][:department_ids].empty?
            @uni_module.errors[:base] << "Module must belong to at least one department."
          end
          if !params[:uni_module][:interest_tags].present? || params[:uni_module][:interest_tags].empty?
            @uni_module.errors[:base] << "Module must have at least one interest tag."
          end
          if !params[:uni_module][:career_tags].present? || params[:uni_module][:career_tags].empty?
            @uni_module.errors[:base] << "Module must have at least one career tag."
          end
          @departments = []
          @careerTags = []
          @interestTags = []
          @required = []
          # If save fails, redisplay the form so user can fix problems
          render('admin/uni_modules/new')
        end

    end


    def edit
      if params[:id].present?
        @uni_module = UniModule.find(params[:id])

        # Get the pre-existing values (if-any)
        @departments = @uni_module.departments.pluck(:name)
        @careerTags = @uni_module.career_tags.pluck(:name)
        @interestTags = @uni_module.interest_tags.pluck(:name)
        @required = @uni_module.uni_modules.pluck(:name)
      end
    end

    def update
      @uni_module = UniModule.find(params[:id])
      if params[:uni_module][:career_tags].present? && !params[:uni_module][:career_tags].empty? && params[:uni_module][:interest_tags].present? && !params[:uni_module][:interest_tags].empty? && params[:uni_module][:department_ids].present? && !params[:uni_module][:department_ids].empty? && @uni_module.update_attributes(uni_module_params)
        @uni_module.departments.clear()
        departments = params[:uni_module][:department_ids].split(',')
        if current_user.user_level == "department_admin_access"
          user_dept = Department.find(current_user.department_id).name
          if !(departments.include? user_dept)
            # If user does not include their own department in the department list.
            @uni_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
            @departments = @uni_module.departments.pluck(:name)
            @careerTags = @uni_module.career_tags.pluck(:name)
            @interestTags = @uni_module.interest_tags.pluck(:name)
            @required = @uni_module.uni_modules.pluck(:name)
            # Redisplay the form so user can fix problems
            render(:edit)
            return
          end
        end
        departments.each do |dept|
          chosen_dept = Department.find_by_name(dept)
          @uni_module.departments << chosen_dept
        end

        @uni_module.uni_modules.clear()
        required = params[:uni_module][:required].split(',')
        required.each do |mod|
          chosen_mod = UniModule.find_by_name(mod)
          @uni_module.uni_modules << chosen_mod
        end

        @uni_module.tags.clear()

        career_tags = params[:uni_module][:career_tags].split(',')
        career_tags.each do |tag|
          chosen_tag = Tag.find_by_name(tag)
          # Add the career tag association
          if(chosen_tag.present?)
            @uni_module.tags << chosen_tag
          else
            # If tag does not already exist then create a new tag
            new_tag = Tag.new(name: tag, type: "CareerTag")
            @uni_module.tags << new_tag
          end
        end

        interest_tags = params[:uni_module][:interest_tags].split(',')
        interest_tags.each do |tag|
          chosen_tag = Tag.find_by_name(tag)
          # Add the interest tag association
          if chosen_tag.present?
            @uni_module.tags << chosen_tag
          else
            # If tag does not already exist then create a new tag
            new_tag = Tag.new(name: tag, type: "InterestTag")
            @uni_module.tags << new_tag
          end
        end

        tag_clean_up

        # Successfully updated
        flash[:success] = "Successfully updated #{@uni_module.name}"
        redirect_to(edit_admin_uni_module_path(@uni_module)) and return

      else
        # Failed to update
        # If save fails, redisplay the form so user can fix problems
        if !params[:uni_module][:department_ids].present? || params[:uni_module][:department_ids].empty?
          @uni_module.errors[:base] << "Module must belong to at least one department."
        end
        if !params[:uni_module][:interest_tags].present? || params[:uni_module][:interest_tags].empty?
          @uni_module.errors[:base] << "Module must have at least one interest tag."
        end
        if !params[:uni_module][:career_tags].present? || params[:uni_module][:career_tags].empty?
          @uni_module.errors[:base] << "Module must have at least one career tag."
        end
        @departments = @uni_module.departments.pluck(:name)
        @careerTags = @uni_module.career_tags.pluck(:name)
        @interestTags = @uni_module.interest_tags.pluck(:name)
        @required = @uni_module.uni_modules.pluck(:name)
        render(:edit)
      end

    end

    # tag generation using opencalais api
    def generate_tags
      uri = URI.parse("https://api.thomsonreuters.com/permid/calais")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      post_body = []
      post_body << "<Document><Body>"
      # stip html
      post_body << ActionView::Base.full_sanitizer.sanitize(params[:desc])
      # no strip
      # post_body << params[:desc]
      post_body << "</Body></Document>"
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field("Content-Type","text/xml")
      request.add_field("outputFormat","application/json")
      #request.add_field("outputFormat","text/n3")    
      request.add_field("x-ag-access-token","fY7WUM3GGCXHm9ATOhtzhrvlWX8oPo5X")
      request.body = post_body.join
      # request["Content-Type"] = "multipart/form-data, boundary=#{BOUNDARY}"

      render :json => http.request(request).body
    end

    # destruction of uni modules only occurs if there are no courses (through groups) using the module. if not, all associated logs are deleted too
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
        @uni_module.comments.each do |comment|
          comment.destroy
        end
        logs = UniModuleLog.all.where(:uni_module_id => @uni_module.id)
          if logs.size >0
            logs.each do |log|
               log.destroy
            end
          end
        pflogs = PathwaySearchLog.all.where(:first_mod_id => @uni_module.id)
          if pflogs.size >0
            pflogs.each do |log|
                log.destroy
            end
          end        
        pslogs = PathwaySearchLog.all.where(:second_mod_id => @uni_module.id)
          if pslogs.size >0
            pslogs.each do |log|
                log.destroy
            end
          end    
        @uni_module.destroy
        tag_clean_up
        flash[:success] = "Successfully deleted module"
        redirect_to admin_uni_modules_path
      else
        flash[:error] = "This module is linked to a course. You must first either unlink or delete those courses."
        redirect_to admin_uni_modules_path
      end

    end

    # similar to destroy action
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
            uni_module.comments.each do |comment|
              logs = UniModuleLog.all.where(:uni_module_id => uni_module.id)
              if logs.size >0
                logs.each do |log|
                  log.destroy
                end
              end
              pflogs = PathwaySearchLog.all.where(:first_mod_id => @uni_module.id)
              if pflogs.size >0
                pflogs.each do |log|
                    pflogs.destroy
                end
              end        
            pslogs = PathwaySearchLog.all.where(:second_mod_id => @uni_module.id)
              if pslogs.size >0
                pslogs.each do |log|
                    pslogs.destroy
                end
              end   
              comment.destroy
            end
            uni_module.destroy
          end

        end
        #uni_module.update_attribute("name", id)

      end

      head :no_content

    end

    # handles the "index" action for a single module's comments
    def comments
      @uni_module = UniModule.find(params[:id])
      @comments = @uni_module.comments
      
      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:sortby].present? && params[:order].present? 
        @sort_by = params[:sortby]
        @order = params[:order]
        @comments = sort(Comment, @comments, @sort_by, @order, @per_page, "created_at")
        @comments = Kaminari.paginate_array(@comments).page(params[:page]).per(@per_page)


      else
        @comments = @comments.order('created_at ASC').page(params[:page]).per(@per_page)
      end


    end

    # allows for bulk deletion of comments
    def bulk_delete_comments
     comment_ids_string = params[:ids]
      comment_ids = eval(comment_ids_string)

      comment_ids.each do |id|
        comment = Comment.find(id.to_i)
        if !comment.nil?
          comment.destroy

        end

      end

      head :no_content

    end

    def bulk_unflag_comments
      comment_ids_string = params[:ids]
      comment_ids = eval(comment_ids_string)

      comment_ids.each do |id|
        comment = Comment.find(id.to_i)
        if !comment.nil?
          comment.reported_users.clear
        end

      end

      head :no_content
    end

    private
    def uni_module_params
      params.require(:uni_module).permit(:name, :code, :description, :semester, :credits, :lecturers, :assessment_methods, :assessment_dates, :exam_percentage, :coursework_percentage, :pass_rate, :more_info_link)
    end

    # verify that the department is correct
    def verify_correct_department
      @uni_module = UniModule.find(params[:id])

      if current_user.user_level == "department_admin_access" && !Department.find(current_user.department_id).uni_module_ids.include?(@uni_module.id)
        redirect_to admin_path
      end
    end

    # delete any unused tags to keep the tag database as clean and up to date as possibl
    def tag_clean_up
      all_tags = Tag.all
      all_modules = UniModule.all

      all_tags.each do |tag|
        is_used_somewhere = false
        all_modules.each do |uni_module|
          if uni_module.tags.include?(tag)
            is_used_somewhere = true
          end
        end
        if !is_used_somewhere
          logs = TagLog.all.where(:tag_id => tag.id)
            if logs.size >0
              logs.each do |log|
                log.destroy
              end
           end
          tag.destroy
        end
      end
    end

  end

end
