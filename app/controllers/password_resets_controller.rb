class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  # User is shown a form prompting for his email address.
  # Given that the email address is valid, an email is sent to the user
  # with further instructions.
  def new
  end

  # Create a new password reset request: email the user with a password reset
  # link.
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # User is shown a form prompting for his new password.
  # Form needs to include :password and :password_confirmation
  def edit
  end

  # Update a user's password after they go through the edit action.
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
  # Find user by email.
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # Whitelist parameters from browser.
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Check expiration of reset token.
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset expired"
      redirect_to new_password_reset_url
    end
  end

  # Confirms a valid user
  def valid_user
    unless (@user &&
            @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end
end
