class SessionsController < ApplicationController

  skip_before_action :store_location
  before_action :already_logged_in, only: [:new, :create]

  # Handles a session (login)

  def new
  end

  # creates a new session with the user's credentials
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    @as = ""
    if params.has_key?(:as) && !params[:as].empty?
      @as = params[:as]
    end

    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or root_url
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash[:danger] = 'Invalid email/password combination'
      if @as == "admin"
        redirect_to admin_login_path
      else
        redirect_to login_path
      end
    end
  end

  # handles the logout/sesions destruction
  def destroy
    log_out if logged_in?
    redirect_to "/"
  end

  private
  def already_logged_in
    if logged_in?
      flash[:warning] = "You're already logged in"
      redirect_to root_url
    end
  end

end
