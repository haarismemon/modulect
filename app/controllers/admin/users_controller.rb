module Admin
  class UsersController < ApplicationController

    def new
      @user = User.new
    end

    def create
      # Instantiate a new object using form parameters
      @user = User.new(user_params)
      # Save the object
      if @user.save
        # If save succeeds, redirect to the index action
        flash[:notice] = "You have successfully created #{@user.full_name} and it's privileges have been granted"
        redirect_to(users_path)
      else
        # If save fails, redisplay the form so user can fix problems
        render(:new)

      end
    end



  end
end