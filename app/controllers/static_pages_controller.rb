class StaticPagesController < ApplicationController

  def home
  	if logged_in?
  		@f_name = current_user.first_name
  	end
  end

  def about
  end

  def contact
  end
  
end
