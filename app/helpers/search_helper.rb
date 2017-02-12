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

end
