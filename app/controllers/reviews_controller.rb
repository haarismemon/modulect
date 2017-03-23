class ReviewsController < ApplicationController
  before_action :check_reviews_allowed
  include ApplicationHelper

  # allows user to view their reviews
  def view
    if !logged_in?

      redirect_to "/"
      flash[:notice] = "You must be logged in to view your module reviews."
    end
  end

  # verify that views haven't been disabled by the system admin
  private
  def check_reviews_allowed
  	redirect_to root_path unless !app_settings.disable_all_reviews
  end

end
