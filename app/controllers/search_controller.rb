class SearchController < ApplicationController

  def home
    retrieve_notices
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

  private

  def retrieve_notices
    if current_user.nil? || current_user.department_id.nil?
      # if user doesn't have a department, equate notices to nil
      @notices = nil
    else
      # if user has a department , display notices
      @notices = Notice.all.where(:department_id => [@current_user.department_id, nil]).where(:broadcast => true).where(['live_date<= ?', DateTime.now])
      auto_delete_notices
    end
  end

  # deletes notices which are past their expiry date
  def auto_delete_notices
    @notices.each { |obj|
      if obj.auto_delete && !obj.end_date.nil? && obj.end_date.past?
        obj.destroy
      end
    }
  end

end
