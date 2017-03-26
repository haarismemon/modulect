module ApplicationHelper

	# A simple helper method which sets the page title
	def full_title(page_title = '')
	    base_title = "Modulect"
	    if page_title.empty?
	      base_title
	    else
	      page_title + " | " + base_title
	    end
	end

	# returns the careers for a module
	def get_careers_for_module(valid_uni_module)
	    @careers = []
	    valid_uni_module.career_tags.each do |careertag|
	      @careers.push(careertag.name)
	    end
	    @careers
	end

	# returns an array of results sorted according to the sort by category
	# inputs are the array of unsorted results, and a string of the category to sort by
	# written by Haaris
	def sort_by(results_array, sort_by_category)
	    if(results_array.is_a?(Array))
	      results_array = Array(results_array)
	    end

	    if results_array.empty? || sort_by_category == ""
	      return results_array
	    end

	    modules_with_weightings = []
	    modules_with_no_weightings = []
	    modules_with_pass_rate = []
	    modules_with_no_pass_rate = []
      modules_with_ratings = []
      modules_with_no_ratings = []

	    results_array.each do |result|
	      uni_module = result[0]
	      # if module has exam + coursework percentage that are not nil, then store in array for weightings
	      if uni_module.exam_percentage && uni_module.coursework_percentage
	        modules_with_weightings << result
	      else
	        modules_with_no_weightings << result
	      end

	      # if module has pass rate that is not nil, then store in array for pass rate
	      if uni_module.pass_rate
	        modules_with_pass_rate << result
	      else
	        modules_with_no_pass_rate << result
	      end

        # if a module has a rating that is not 0, then store in array for ratings
        if module_average_rating(uni_module) != 0
          modules_with_ratings << result
        else
          modules_with_no_ratings << result
        end
	    end

	    if sort_by_category == "coursework"
	      # sorted results according to coursework percentage
	      results_with_attribute = modules_with_weightings.sort_by { |result| [result[0].coursework_percentage, result[1].size] }
	      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
	      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}
	      return (results_without_attribute.concat results_with_attribute).reverse
	    elsif sort_by_category == "exam"
	      # sorted results according to exam percentage
	      results_with_attribute = modules_with_weightings.sort_by { |result| [result[0].exam_percentage, result[1].size] }
	      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
	      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}
	      return (results_without_attribute.concat results_with_attribute).reverse
	    elsif sort_by_category == "pass"
	      # sorted results according to pass rate
	      results_with_attribute = modules_with_pass_rate.sort_by { |result| [result[0].pass_rate, result[1].size] }
	      # sort the remaining modules (without the pass rate attribute) according to number of tags matched
	      results_without_attribute = modules_with_no_pass_rate.sort_by {|result| result[1].size}
	      return (results_without_attribute.concat results_with_attribute).reverse
	    elsif sort_by_category == "rating"
        # sort the results by their average rating
        results_with_attribute = modules_with_ratings.sort_by {|result| [module_average_rating(result[0]), result[1].size] }
        # sort the remaining modules (with rating 0) according to number of tags matched
	     	results_without_attribute = modules_with_no_ratings.sort_by {|result| result[1].size}
        return (results_without_attribute.concat results_with_attribute).reverse
	    end

      return results_array

  	end

    # returns the sorted array of pathways of a user
    # inputs are the user object and a string of the way to sort the pathways
    # written by Haaris
    def sort_pathways(user, ways)
      user_pathways = Array(user.pathways)
      result = []

      if ways == "name"
        result = user_pathways.sort_by { |pathway| pathway.name }
      elsif ways == "date_created"
        result = user_pathways.sort_by { |pathway| pathway.created_at }.reverse
      end

      result
		end



  	# converts an input array into a results type (Haaris')
  	# written by Aqib
  	def convert_to_results_array(input)
  	  results = {}
  	  input.each do |unimodule|
   	   results[unimodule] = []
   	 end
		results
  	end

	# creates and renders a div error box containing all errors related to the object in question
	def error_messages_for(object)
		render(:partial => 'admin/application/admin_form_error', :locals => {:object => object})
	end

	# returns true if the user is a department or system admin
	# by Aqib
	def is_admin
		# I know that the quicker way to write this
		# is to check if a user is a student and return false if they are
		# and true if not (so an admin) accordingly. 
		# But the enum "user_access" is a bit confusing
		# so I took the longer route
		if current_user.user_level == "super_admin_access" || current_user.user_level == "department_admin_access"
			true
		else 
			false
		end
	end

	# returns the admin type of the current user
	def admin_type
		if current_user.user_level == "super_admin_access"
			"System"
		else 
			"Department"
		end
	end

  # checks if the form is being rendered by the edit page instead of the new page for a model associated in admin
  def is_edit_form(param_input)
    if param_input.has_key?(:action)&&param_input[:action]=="edit"
      true
    else
      false
    end
  end

  # returns user level match. return true if matches with input
  def check_user_level(id,user_level_to_check)
    user = User.find(id)
    (user_level_to_check == User.user_levels[user.user_level]) # Returns the integer value
  end

  # Specifies the allowed attributes to show on the user's show page
  def filter_for_user_show(attribute)
    user_level = User.user_levels[User.find(params[:id]).user_level]
    # super admin's attributes not to show
    super_admin_filter = user_level == 1 && attribute != "course" &&
        attribute != "year_of_study" && attribute != "faculty" && attribute != "departments"
    # department admin's attributes not to show
    department_admin_filter = user_level == 2 && attribute != "course" &&
        attribute != "year_of_study"
    # user's attributes not to show
    user_filter = user_level == 3
    super_admin_filter || department_admin_filter || user_filter
	end




  # specifies whether current admin form has any errors
  def form_valid?(page)
		(page && page.errors.size == 0)
  end

  def make_semester_nice(semester_number)
	if semester_number == "No data available"
	  "No data available"
	elsif semester_number == "0"
	  "1 or 2"
	elsif semester_number == "1"
	  "1"
	elsif semester_number == "2"
	  "2"
	else
	  "1 & 2"
	end
	end

	#attribute object must have name as an attrbute
	#check if obect has a link with the another
	#if it does create a link to edit page of that object on click
	def generate_linked_attribute(path,object,attribute)
		collection = object.send(attribute)
		if collection.present?
			return link_to object.send(attribute).name.to_s,path
		end
		"-"
	end

	# returns the name of a association given the object and attribute
	def find_name_of_association(object,attribute)
		begin
			object.send(attribute).name
		rescue
			""
		end
  end

  # finds the average star rating of a module from its reviews and rounds the value
  # input is a uni_module object, and output is average rating
  # written by Haaris
  def module_average_rating(uni_module)
    total = 0.0
    average = 0.0
    comments = uni_module.comments

    comments.each do |comment|
      total += comment.rating
    end

    if comments.length != 0
      average = total / comments.length
		  ((average)*2).round / 2.0
    else
      average
    end
  end


  # return app_settings object
  def app_settings
    AppSetting.instance
  end

  # add a type of search to the search log by checking if the type of search firstly exists and if it does increment a counter. if not it creates a new record.
  def add_to_search_log(type)
  	logs = SearchLog.select{|log| log.search_type == type && log.created_at.hour == Time.now.utc.hour}
  	if logs.size > 0
  		updated_some_log = false
  		logs.each do |log|

  			if (log.department_id.present? && logged_in? && current_user.department_id.present? && current_user.department_id == log.department_id) || !logged_in?

	  			log.update_attribute("counter", log.counter + 1)
	  			log.save
	  			updated_some_log = true
	  			break
	  		elsif logged_in? && !current_user.department_id.present?	
	  			log.update_attribute("counter", log.counter + 1)
	  			updated_some_log = true
	  			break
	  		end

  		end

  		if !updated_some_log
  			if logged_in? && current_user.department_id.present?
  				SearchLog.create(:search_type => type, :counter => 1, :department_id => current_user.department_id)
  			end
  		end

  	else
  		if logged_in? && current_user.department_id.present?
  			SearchLog.create(:search_type => type, :counter => 1, :department_id => current_user.department_id)
  		else
  			SearchLog.create(:search_type => type, :counter => 1)
  		end
	end

  end

  # adds a uni module to the uni module log for analytics, once again checking if there is an existing record
  def add_to_uni_module_log(incoming_uni_module_id)
  	logs = UniModuleLog.select{|log| log.uni_module_id == incoming_uni_module_id && log.created_at.to_date == Time.now.to_date}
  	if logs.size > 0
  		desired_log = logs.first
  		desired_log.update_attribute("counter", desired_log.counter + 1)
  	else
  		UniModuleLog.create(:uni_module_id => incoming_uni_module_id, :counter => 1)
  	end

  end

  # similar to previous action but for tags
  def add_to_tag_log(incoming_tag_id)
  	logs = TagLog.select{|log| log.tag_id == incoming_tag_id && log.created_at.to_date == Time.now.to_date}
  	if logs.size > 0
  		desired_log = logs.first
  		desired_log.update_attribute("counter", desired_log.counter + 1)
  	else
  		TagLog.create(:tag_id => incoming_tag_id, :counter => 1)
	end
  end
  
  # formats the input into a "nth year, Course name" format
  def get_course_and_year(user, prestring)
  	if user.year_of_study.present? && !user.course_id.nil?
  		", " + user.year_of_study.ordinalize + " year " + Course.find(user.course_id).name
  	end
  end

  private
  # determines what the link needs to be to redirect back to faculty form
  def determine_redirect_link_from_previous_state
    # redirect back to edit form of faculty
    if(session[:data_save]["faculty"].present?&&session[:data_save]["isEdit"])
      link_to 'Back', edit_admin_faculty_path(id: session[:data_save]["faculty"]["id"]), class: "button"
    else
      #redirect back to new form
      link_to 'Back', new_admin_faculty_path, class: "button"
    end
  end
end
