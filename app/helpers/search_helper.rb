module SearchHelper

  # returns the course object of the logged in user
	def get_course_of_user(user)
		course_obj = Course.find_by_id(user.course_id)
  end

  # returns an array of all tags relating to a course including the module name and code
  # input is a course object
  def every_tag_for_course(course)
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
          all_tags.concat uni_module.tags.pluck(:name)
          all_tags << uni_module.name
          all_tags << uni_module.code
          
        end
      end
    end

    # returns an array of tags with no duplicates
    all_tags
  end

  # returns an array of all modules in a course
  def modules_in_course(course)
    courseMods = []
    year_structures = course.year_structures
    year_structures.each do |year_structure|
      groups.each do |group|
        courseMods + UniModule.all_modules_in_group(group).pluck(:name)
      end
    end
    courseMods
  end

end
