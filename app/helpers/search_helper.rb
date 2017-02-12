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

	# returns percentage tag match on input
	# written by Aqib
	def percentage_tag(module_matched, total)
		(module_matched / total) * 100
	end

	# returns percentage tag match on input
	# written by Aqib
	def count_tag(module_matched, total)
		"#{module_matched} out of #{total}"
	end

	# returns true if searched directly for a module in search
	def direct_search_check(module_code, module_matched_list, tags_matched_list)
		if module_matched_list.include?(module_code) && 
			tags_matched_list.include?(module_code) 
			true
		else 
			false
		end
	end

end
