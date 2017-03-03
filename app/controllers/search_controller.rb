class SearchController < ApplicationController

  def home
    @tag_names = Tag.pluck(:name)
    @module_names = UniModule.pluck(:name)
    @module_code = UniModule.pluck(:code) 
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
    if params.has_key?(:search_course) && !params[:search_course].empty?
      @search_course = params[:search_course] == "true"
    else
      @search_course = false
    end
  end

end
