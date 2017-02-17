class SavedController < ApplicationController

  def view
    if !logged_in?

     redirect_to "/"
      flash[:notice] = "You must be logged in to view saved modules."
    end
  end

  def save_module
      uni_module = UniModule.find(params[:module_par])
      if(current_user.uni_modules.include?(uni_module))
        current_user.unsave_module(uni_module)
      else
        current_user.save_module(uni_module)
      end
  end


end
