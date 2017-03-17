class ReviewsController < ApplicationController

  def view
    if !logged_in?

      redirect_to "/"
      flash[:notice] = "You must be logged in to view your module reviews."
    end
  end

end
