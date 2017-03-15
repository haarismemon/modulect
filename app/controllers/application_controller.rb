class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :admin_has_dept
  before_action :modulect_is_online

  include ApplicationHelper
  include SessionsHelper
  before_action :store_location
  before_action :log_visit

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

  # if offline and not on an error page nor admin, redirect to offline page
  # super admins are not redirected
  def modulect_is_online
    if app_settings.is_offline && controller_name != "errors" && (request.path  =~ /.*\/admin(\/.*)?/) == nil
      if !logged_in? || (logged_in? && current_user.user_level != "super_admin_access")
        redirect_to offline_path
      end
    end
  end

  def log_visit
    session_id = request.session_options[:id]
    client = DeviceDetector.new(request.env["HTTP_USER_AGENT"])
    client_os = client.os_name 
    if !VisitorLog.find_by_session_id(session_id)
      VisitorLog.create(:session_id => session_id, :logged_in => false, :device_type => client_os)
    end

    if VisitorLog.find_by_session_id(session_id)
      log = VisitorLog.find_by_session_id(session_id)
      if !log.logged_in && logged_in?
        log.update_attribute("logged_in", true)
        log.save
      end

      if logged_in? && current_user.department_id.present? && log.department_id.nil?
        log.update_attribute("department_id", current_user.department_id)
        log.save
      end
    end

  end

end
