class SearchController < ApplicationController

  def quick_search
    @all_tags = Tag.all
  end

  def smart_search
    @all_tags = Tag.all
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
