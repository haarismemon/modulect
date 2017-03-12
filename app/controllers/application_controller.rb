class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :admin_has_dept

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

  # Save pathway to favourites
  def save_pathway
    pathway_name = params[:name]
    pathway_data = params[:data]
    pathway_year = params[:year]
    pathway_course = params[:course]
    current_user.pathways << Pathway.create(name: pathway_name, data: pathway_data, year: pathway_year, course_id: pathway_course)
  end

  # delete pathway from user's favourites
  def delete_pathway
    pathway = Pathway.find(params[:pathway_par])
    current_user.pathways.delete(pathway)
  end

  private
  def admin_has_dept
    if logged_in? && admin_user && current_user.user_level == "department_admin_access" && !current_user.department_id.present?
      log_out
      redirect_to root_path
          flash[:error] = "You have not been assigned a department. Contact the System Administrator."
    end
  end


end
