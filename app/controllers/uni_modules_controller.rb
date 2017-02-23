class UniModulesController < ApplicationController


  def show
    @uni_module = UniModule.find(params[:id])
  end


end