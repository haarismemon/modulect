class SavedController < ApplicationController

  def view
    if !logged_in?

     redirect_to "/"
      flash[:notice] = "You must be logged in to view saved modules."
    end
  end

end
