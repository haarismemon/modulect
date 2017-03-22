class ErrorsController < ApplicationController
  
  include ApplicationHelper


  def not_found
    render(:status => 404)
  end

  def internal_server_error
    render(:status => 500)
  end

  # if modulect switched offline by system admin, redirect
  def offline
  	if !app_settings.is_offline
  		redirect_to root_path
  	end
    
  end

end