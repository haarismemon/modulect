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


    def edit
      #! allows for template's form to be ready populated with the associated users data ready for modification by admin
      @user = User.find(params[:id])
    end

    def update
      # Find a  object using id parameters
      @user = User.find(params[:id])
      # Update the object
      if @user.update_attributes(user_params)
        # If save succeeds, redirect to the index action
        flash[:success] = "Successfully updated "+ @user.full_name
        redirect_to(admin_user_path(@user)) and return
      else
        # If save fails, redisplay the form so user can fix problems
        render('edit')
      end
    end


    private

    def user_params
      #!add params that want to be recognized by this application
      params.require(:user).permit(:first_name, :last_name, :email, :password, :username, :year_of_study,:user_level)
    end

  end
end