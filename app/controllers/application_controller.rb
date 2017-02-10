class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  def print_flash(condition,message_if_true,message_if_false)
    if condition
       flash[:notice] = message_if_true
    else
      flash[:notice] = message_if_false
    end
  end
end
