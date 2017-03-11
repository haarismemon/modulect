class UniModulesController < ApplicationController

  def show
    @uni_module = UniModule.find(params[:id])
    @comments = @uni_module.comments.order("created_at DESC")
  end

end
