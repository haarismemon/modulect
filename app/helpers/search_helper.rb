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


end
