class SearchController < ApplicationController

  def quick_search
    @tag_names = Tag.pluck(:name)
    @module_names = UniModule.pluck(:name)
    @module_code = UniModule.pluck(:code) 
  end

  def pathway_search
    @tag_names = Tag.select(:name)
    @module_names = UniModule.select(:name)
    @module_code = UniModule.select(:code)
  end

  def view_results
    @tag_names = Tag.pluck(:name)
    @module_names = UniModule.pluck(:name)
    @module_code = UniModule.pluck(:code) 
    @results = []
    if params.has_key?(:chosen_tags) && !params[:chosen_tags].empty?
      @temp_array = params[:chosen_tags].split(",")
      @results = UniModule.basic_search(@temp_array)
    else
     redirect_to "/"
    end
  end

  def view_saved

  end


  def save_module
      uni_module = UniModule.find(params[:module_par])
      if(current_user.uni_modules.include?(uni_module))
        current_user.unsave_module(uni_module)
      else
        current_user.save_module(uni_module)
      end
  end



end
