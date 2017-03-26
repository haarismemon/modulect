module CareerSearchHelper

	# returns the alphabetically sorted array of career tags associated with the array of modules passed in
    # input is the array of uni modules and output is the array of career tags associated
    # written by Haaris
	def get_career_tags_from_modules(modules)
    result_career_tags = []
	  modules = Array(modules)
      # only find the career tags if the array of modules is not empty
      if !modules.empty?
        modules.each do |uni_module|
          result_career_tags.concat uni_module.career_tags
        end

        result_career_tags = result_career_tags.uniq.map!
      end

      if result_career_tags.size > 0
         result_career_tags.sort_by { |career_tag| career_tag.name }
  	  else
         result_career_tags
      end

	end

  # check which modules contain which the input tag
  # written by Aqib
  def get_module_which_contains_tag(tag, modules)

    resulting_modules = []

    modules.each do |uni_module|
      if uni_module.career_tags.include?(tag)
        resulting_modules << uni_module
      end
    end

    resulting_modules

  end

  # check that a course contains modules
  # by looping over year strucutres, then groups
  # and increasing a counter
  # by Aqib
  def check_course_contains_modules(course_obj)
    module_count = 0

    course_obj.year_structures.each do |ys|
      ys.groups.each do |group|
        module_count += group.uni_modules.size
      end
    end
    
    if module_count == 0
      false
    else 
      true
    end
  end
end
