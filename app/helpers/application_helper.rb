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

	# A simple helper method which sets the page title on admin
	def full_title_admin(page_title = '')
	    base_title = "Modulect"
	    if page_title.empty?
	     "Admin | " + base_title
	    else
	      page_title + " - Admin | " + base_title
	    end
	end


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


  # Creates redirect back button for department form only
  def back_redirect_for_department(page)
     if !form_valid?(page)
      # redirects back to faculty form if initially came from there
      determine_redirect_link_from_previous_state
     else
      #or just go back to last page like normal-->
      link_to 'Back', :back, class: "button"
     end
  end

  # specifies whether current admin form has any errors
  def form_valid?(page)
     (page.resource && page.resource.errors.size == 0)
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
