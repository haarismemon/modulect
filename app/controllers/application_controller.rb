class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  before_action :store_location

  # Confirms a logged in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_path
    end
  end


 # Save module to favourites
 def save_module
      uni_module = UniModule.find(params[:module_par])
      if(current_user.uni_modules.include?(uni_module))
        current_user.unsave_module(uni_module)
      else
        current_user.save_module(uni_module)
      end
  end

end
