module Admin
  class NoticesController < Admin::BaseController

    def index
      # checks current user status
      if current_user.user_level == "super_admin_access"
        # if super admin only display global notices
        @notices = Notice.all
      else
        # if department admin only display department notices
        @notices = Notice.all.where(:department_id => [@current_user.department_id])
      end
      auto_delete_notices

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @notices = @notices.select { |notice| notice.header.downcase.include?(params[:search].downcase) }.sort_by { |notice| notice[:header] }
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @notices = sort(Notice, @notices, @sort_by, @order, @per_page, "header")
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)
      else
        @notices = @notices.order('header ASC').page(params[:page]).per(@per_page)
      end

    end

    def new
      # creates new notice
      @notice = Notice.new
    end

    def create
      # Instantiate a new object using form parameters
      @notice = Notice.new(notice_params)
      # if super_admin user, keep department id of notice to nil as a indication to display everywhere
      if current_user.user_level != "super_admin_access"
        # sets department id of notice to be the same as currently signed user
        @notice.department_id = @current_user.department_id
      end
      # Save the object
      if @notice.save
        # If save succeeds, redirect to the index action
        flash[:success] = "The notice has successfuly been created "+(@notice.broadcast ? "and is currently live." : "")
        redirect_to(admin_notices_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render("admin/notices/new")

      end
    end


    def edit
      @notice = Notice.find(params[:id])
      #! allows for template's form to be ready populated with the associated notice data ready for modification by admin )
    end


    def update
      # Update the object
      @notice = Notice.find(params[:id])
      if @notice.update_attributes(notice_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "The notice has successfuly been created "+(@notice.broadcast ? "and is currently live." : "")
        redirect_to(edit_admin_notice_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/notices/edit')
      end
    end


    def destroy
      @notice = Notice.find(params[:id])
      #delete tuple object from db
      @notice.destroy
      flash[:success] = "Successfully deleted notice"
      #redirect to action which displays all notices
      redirect_to(admin_notices_path)
    end

    def bulk_delete
      notices_ids_string = params[:ids]
      notices_ids = eval(notices_ids_string)

      notices_ids.each do |id|
        notice = Notice.find(id.to_i)

        if !notice.nil?
          notice.destroy
        end

      end

      head :no_content
    end

    def clone
      notices_ids_string = params[:ids]
      notices_id = eval(notices_ids_string)

      notices_id.each do |id|
        notice = Notice.find(id.to_i)

        if !notice.nil?
          cloned = notice.dup
          cloned.update_attribute("header", cloned.header + "-CLONE")
        end

      end

      head :no_content
    end

    private

    def notice_params
      #!add params that want to be recognized by this application
      params.require(:notice).permit(:header, :notice_body, :live_date, :end_date, :broadcast, :optional_link, :auto_delete)
    end


    # deletes notices which are past their expiry date
    def auto_delete_notices
      @notices.each { |obj|
        if obj.auto_delete && !obj.end_date.nil? && obj.end_date.past?
          obj.destroy
        end
      }
    end


  end
end
