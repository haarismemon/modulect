module PathwaySearchHelper

  # returns a boolean if the next year of the course is defined and iterates the current year to that year
	def exists_next_year_for(course_id, current_year)
		if !YearStructure.where("course_id = ? AND year_of_study = ?", course_id, ++current_year).empty?
      @year_of_study = (@year_of_study.to_i + 1).to_s
			true
		else
			false
		end
	end

  # returns an array of all tags relating to a course
  # input is a course object
  # written by Haaris
  def all_tags_of_course(course)
    all_tags = []

    year_structures = course.year_structures
    # search through each year structure for groups of modules
    year_structures.each do |year_structure|
      groups = year_structure.groups
      # search within each group of a year structure for modules
      groups.each do |group|
        modules = UniModule.all_modules_in_group(group)
        # search within each module of a group for tags
        modules.each do |uni_module|
          all_tags.concat uni_module.tags
        end
      end
    end

    # returns an array of tags with no duplicates
    all_tags.uniq!
  end

  # uses above helper to get all the tag names
  def all_tag_name_of_course(course)
    all_tags_of_course(course).pluck(:name)
  end

  # returns a string used to colour code card based on number of tags matched
  # inputs are a string and lists
  # written by Aqib adapted by Feras
  def colour_code_card_group(module_matched_list, tags_matched_list)
    if percentage(module_matched_list.length, tags_matched_list.length) >= 60.0
      "green"
    else
      "orange"
    end
  end

  def compulsory_modules_of_group(group)
    @compulsory = []
    group.uni_modules.select('uni_modules.*, groups_uni_modules.compulsory').each do |uni_module|
      if uni_module.compulsory 
        @compulsory << uni_module
      end
    end
  end

end
