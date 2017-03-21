class UniModulesController < ApplicationController

  # default show action for a uni module
  def show
    @uni_module = UniModule.find(params[:id])
    @comments = @uni_module.comments.order("created_at DESC")
  end

end
