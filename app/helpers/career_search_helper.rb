module CareerSearchHelper

	# returns the alphabetically sorted array of career tags associated with the array of modules passed in
    # input is the array of uni modules and output is the array of career tags associated
    # written by Haaris
	def get_career_tags_from_modules(modules)
      result_career_tags = []

	  modules = Array(modules)
      # only find the career tags if the array of modules is not empty
      if !modules.empty?
        # loop through all modules in the array
		modules.each do |uni_module|
          # append the module's career tags to the result
          result_career_tags.concat uni_module.career_tags
        end

        # remove any duplicate career tags in the result
        result_career_tags = result_career_tags.uniq.map!
      end

      if result_career_tags.size > 0
         result_career_tags.sort_by { |career_tag| career_tag.name }
  	  else
         result_career_tags
      end

	end


end
