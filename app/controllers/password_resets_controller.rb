class PasswordResetsController < ApplicationController
  # User is shown a form prompting for his email address.
  # Given that the email address is valid, an email is sent to the user
  # with further instructions.
  def new
  end

  # Create a new password reset request: email the user with a password reset
  # link.
  def create
  end

  # User is shown a form prompting for his new password.
  # Form needs to include :password and :password_confirmation
  def edit
  end

  # Update a user's password after they go through the edit action.
  def update
  end
end
