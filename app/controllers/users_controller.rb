class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create_by_admin
    @user = User.new(user_creation_params)
    if @user.save
      if
        #! after person has signed up redirects back out to login page #change path#
        redirect_to(list_path)
      else
        render(:edit)
      end
    end
  end


  def create_by_signup
    @user = User.new(user_creation_params)
    if @user.save
      if
        #! after person has signed up redirects back out to login page #change path#
        redirect_to(login_path)
      end
      render(:login)
      flash.now[:notice] = "Failed to create"
    end
  end

  def edit
    #! allows for template's form to be ready populated with the associated users data ready for modification by admin
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "You have successfully updated "+ @user.full_name
      redirect_to(page_after_login_for_admin) and return
    else
      flash.now[:notice] = "Failed to update"
      render('edit')
    end
  end

  def delete
    @user = User.find(params[:id])
    full_name = @user.full_name
    @user.destroy
    print_flash(@user.destroyed?,"You have removed #{full_name} from the database","You have failed to delete")
    ##defined in application_controller // see
  end

  #! index can either show all results when first accessed by admin intially or allowed to come up with results based on input/search given by
  #! Admin which will just redirect to same action. A dropdown specifies type( searchable attributes of user i.e email) and textfield specifies search
  def index
    @search_results = []
    if (params.has_key?(:search)&&params.has_key?(:type))
      @search_results = User.search_by_type(params[:search], params[:type]).order(params[:type]+" ASC")
      if @search_results.empty?
        flash.now[:notice] = "There are no results found"
      end
    else
      @search_results = User.all
    end
  end

  private

  def user_creation_params
    #!add params that want to be recognized by this application
    params.require(l: user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
  end
end
end
