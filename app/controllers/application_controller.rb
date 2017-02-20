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

  # Save pathway to favourites
  # Feras, the pathway has a name "Pathway" by default
  # so you might need to modify this function accordingly or whatever
  # delete this comment afterwards please
  def save_pathway
    pathway_name = params[:name]
    pathway_data = params[:data]
    current_user.pathways << Pathway.create(name: pathway_name, data: pathway_data)
  end

  # delete pathway from user's favourites
  def delete_pathway
    pathway = Pathway.find(params[:pathway_par])
    current_user.pathways.delete(pathway)
  end

end
