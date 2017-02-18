module PathwaySearchHelper

	def exists_next_year_for(course_id, current_year)
		if !YearStructure.where("course_id = ? AND year_of_study = ?", course_id, ++current_year).empty?
      ++@year_of_study
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

end
