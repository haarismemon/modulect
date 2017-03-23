class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :admin_has_dept
  before_action :modulect_is_online
  before_action :store_location
  before_action :log_visit

  include ApplicationHelper
  include SessionsHelper

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
    if current_user.pathways.size < 1
    respond_to do |format|
      format.html { redirect_to '/saved#pathways' }
      format.json { head :no_content }
    end
    end
  end

  # saves a suggested course pathway
  def save_suggested_course_pathway
    course = Course.find_by(id: params[:course])
    suggested_pathway_name = params[:name]
    suggested_pathway_data = params[:data]
    suggested_pathway_year = params[:year]
    suggested_pathway_course = params[:course]
    course.suggested_pathways << SuggestedPathway.create(name: suggested_pathway_name, data: suggested_pathway_data, year: suggested_pathway_year, course_id: suggested_pathway_course)
  end

  # updates a suggested course pathway
  def update_suggested_course_pathway
    suggested_pathway = SuggestedPathway.find_by(id: params[:id])
    suggested_pathway.name = params[:name]
    suggested_pathway.year = params[:year]
    suggested_pathway.course_id = params[:course_id]
    suggested_pathway.data = params[:data]
    suggested_pathway.save
    render json: suggested_pathway
  end

  # deletes a suggested course pathway
  def delete_suggested_course_pathway
    suggested_pathway = SuggestedPathway.find_by_id(params[:pathway_id])
    suggested_pathway.destroy
    render json: suggested_pathway
  end

  # Retrieve module rating
  def rating_for_module
    uni_module = UniModule.find_by_id(params[:mod])
    module_average_rating(uni_module)
  end

  private
  def admin_has_dept
    if logged_in? && admin_user && current_user.user_level == "department_admin_access" && !current_user.department_id.present?
      log_out
      redirect_to root_path
      flash[:error] = "You have not been assigned a department. Please contact the System Administrator."
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

  # logs a user's visit by obtaining their device type and whether or not they were logged in
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
