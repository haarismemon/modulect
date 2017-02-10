class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create_by_admin
    @user = User.new(user_creation_params)
    if @user.save
      flash[:notice] = "You have successfully created #{@user.full_name} and it's privileges have been granted"
      redirect_to(users_path)
    else
      flash.now[:notice] = "Lack of information prohibited this record from being saved"
      render(:edit)

    end
  end


  def create_by_signup
    @user = User.new(user_creation_params)
    if @user.save
      #!succeded
      flash[:notice] = "You must confirm your email before accessing your account"
      #! after person has signed up redirects back out to login page #change path#
        #redirect_to(login_path)
    else
      #! validations were broken and re-render sign up page showing the errors (uncomment when such a template called sign up exists)
      flash.now[:notice] = "Lack of information prohibited this record from being saved"
      #render(:sign_up_template)

    end
  end


  def edit
    #! allows for template's form to be ready populated with the associated users data ready for modification by admin
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_creation_params)
      flash[:notice] = "You have successfully updated "+ @user.full_name
      redirect_to(page_after_login_for_admin) and return
    else
      flash.now[:notice] = 'Lack of information prohibited this record from being updated'
      render('edit')
    end
  end

  def delete
    @user = User.find(params[:id])
    full_name = @user.full_name
    @user.destroy
    print_flash(@user.destroyed?,"You have removed #{full_name} from the database","Occurence prohibited this record from being deleted")
    ##defined in application_controller // if true flash first message if false flash second
  end

  #! index can either show all results when first accessed by admin intially or allowed to come up with results based on input/search given by
  #! Admin which will just redirect to same action. A dropdown specifies type( searchable attributes of user i.e email) and textfield specifies search
  def index
    @users = []
    if (params.has_key?(:search)&&params.has_key?(:type))
      @users = User.search_by_type(params[:search], params[:type]).order(params[:type]+" ASC")
      if @users.empty?
        flash.now[:notice] = "There are no results found"
      end
    else
      @users = User.all
    end
  end

  private

  def user_creation_params
    #!add params that want to be recognized by this application
    params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
  end
end
