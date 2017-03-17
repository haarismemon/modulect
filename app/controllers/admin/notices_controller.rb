module Admin
  class NoticesController < Admin::BaseController
    before_action :verify_correct_department, only: [:destroy, :update, :edit]

    def index
      @notices = Notice.all.where(department_id: @current_user.department_id)

      if params[:per_page].present? && params[:per_page].to_i > 0
        @per_page = params[:per_page].to_i
      else
        @per_page = 20
      end

      if params[:search].present?
        @search_query = params[:search]
        @notices = @notices.select { |notice| notice.title.downcase.include?(params[:search].downcase) }.sort_by { |notice| notice[:title] }
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)

      elsif params[:sortby].present? && params[:order].present? && !params[:search].present?
        @sort_by = params[:sortby]
        @order = params[:order]
        @notices = sort(Notice, @notices, @sort_by, @order, @per_page, "title")
        @notices = Kaminari.paginate_array(@notices).page(params[:page]).per(@per_page)
      else
        @notices = @notices.order('title ASC').page(params[:page]).per(@per_page)
      end

    end

    def new
      # creates new notice
      @notice = Notice.new
    end

    def create
      # Instantiate a new object using form parameters
      @notice = Notice.new(user_params)
      # sets department id of notice to be the same as currently signed user
      @notice.department_id = @current_user.department_id
      # Save the object
      if @notice.save
        # If save succeeds, redirect to the index action
        flash[:success] = "The notice has successfuly been created "+@notice.broadcast ? "and is currently live." : ""
        redirect_to(admin_notices_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render("admin/noticeS/new")

      end
    end


    def edit
      #! allows for template's form to be ready populated with the associated notice data ready for modification by admin
      @notice = Notice.find(params[:id])
    end


    def update
      # Find a  object using id parameters
      @notice = Notice.find(params[:id])
      # Update the object
      if @notice.update_attributes(notice_params)
        # If save succeeds, redirect to the index action
        "The notice has successfuly been created "+@notice.broadcast ? "and is currently live." : ""
        redirect_to(edit_admin_notice_path) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('admin/notices/edit')
      end
    end


    def destroy
      #find by id
      @notice = Notice.find(params[:id])
      #delete tuple object from db
      @user.destroy
      flash[:success] = "notice has been deleted successfully."
      #redirect to action which displays all users
      redirect_to(admin_notices_path)
    end


    private

    def notice_params
      #!add params that want to be recognized by this application
      params.require(:notice).permit(:title, :notice_body, :display_period, :date_of_event, :broadcast, :additional_link)
    end


  end
end
