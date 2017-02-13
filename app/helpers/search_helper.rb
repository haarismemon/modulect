module SearchHelper

	# returns "No data" string if input is empty since no data was provided in model
	# written by Aqib
	def size_check(input)
		if input.nil? || input.length == 0
			"No data available"
	 	else
	 		input
	 	end

	end

	# returns percentage matched as a float
	# inputs are numbers
	# written by Aqib
	def percentage(module_matched, total)
		(Float(module_matched) / total) * 100
	end

	# returns percentage tag match on input
	# inputs are numbers
	# written by Aqib
	def percentage_tag(module_matched, total)
		percentage_to_display = percentage module_matched, total
		"#{percentage_to_display.round}%"
	end

	# returns percentage tag match on input
	# inputs are numbers
	# written by Aqib
	def count_tag(module_matched, total)
		"#{module_matched} out of #{total}"
	end

	# returns true if searched directly for a module in search
	# inputs area string and lists
	# written by Aqib
	def direct_search_check(module_code, module_matched_list, tags_matched_list)
		if module_matched_list.include?(module_code) && 
			tags_matched_list.include?(module_code) 
			true
		else 
			false
		end
	end

	# returns a string used to colour code card based on number of tags matched
	# inputs are a string and lists
	# written by Aqib
	def colour_code_card(module_code, module_matched_list, tags_matched_list)
		if direct_search_check(module_code, module_matched_list, tags_matched_list) ||
			percentage(module_matched_list.length, tags_matched_list.length) >= 60.0
			"green"
		else
			"orange"
		end
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
      results_with_attribute = modules_with_weightings.sort_by {|result| result[0].coursework_percentage}.reverse
      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}.reverse
      return results_with_attribute.concat results_without_attribute
    elsif sort_by_category == "exam"
      # sorted results according to exam percentage
      results_with_attribute = modules_with_weightings.sort_by {|result| result[0].exam_percentage}.reverse
      # sort the remaining modules (without the exam/coursework attribute) according to number of tags matched
      results_without_attribute = modules_with_no_weightings.sort_by {|result| result[1].size}.reverse
      return results_with_attribute.concat results_without_attribute
    elsif sort_by_category == "pass"
      # sorted results according to pass rate
      results_with_attribute = modules_with_pass_rate.sort_by {|result| result[0].pass_rate}.reverse
      # sort the remaining modules (without the pass rate attribute) according to number of tags matched
      results_without_attribute = modules_with_no_pass_rate.sort_by {|result| result[1].size}.reverse
      return results_with_attribute.concat results_without_attribute
    end

    return results_array

  end


end
