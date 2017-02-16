class SessionsController < ApplicationController

  skip_before_filter :store_location
  before_action :already_logged_in, only: [:new, :create]

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or root_url
      else
        message = "Account not activated."
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_back_or root_url
  end

  def already_logged_in
    if logged_in?
      flash[:warning] = "You're already logged in"
      redirect_to root_url
    end
  end
end
