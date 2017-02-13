class SearchController < ApplicationController

  def quick_search
    @tag_names = Tag.pluck(:name)
    @module_names = UniModule.pluck(:name)
    @module_code = UniModule.pluck(:code) 
  end

  def smart_search
    @tag_names = Tag.select(:name)
    @module_names = UniModule.select(:name)
    @module_code = UniModule.select(:code)
  end

  def view_results
    @results = []
    if params.has_key?(:chosen_tags) && !params[:chosen_tags].empty?
      @temp_array = params[:chosen_tags].split(",")
      @results = UniModule.basic_search(@temp_array)
    else
      render('quick_search')
    end
  end

  def view_saved

  end
end
