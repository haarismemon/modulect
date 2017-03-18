module PathwaySearchHelper

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
    @all_tags = all_tags_of_course(course)
    if !@all_tags.nil?
      @all_tags = @all_tags.pluck(:name)
    else
      @all_tags = {}
    end
  end

  # retuns a default string if name not set
  def check_pathway_name(input)
    if input == "Pathway"
      "Pathway (no name)"
    else
      input
    end
  end 

  # adds a tuple pair to the database when two modules are selected in the same pathway
  def add_to_pathway_search_log(first_mod_id, second_mod_id, department_id, course_id)
    # Tuples are arranged with the module with the lower id being first
    mod_a = -1
    mod_b = -1
    if first_mod_id < second_mod_id
      mod_a = first_mod_id
      mod_b = second_mod_id
    else 
      mod_a = second_mod_id
      mod_b = first_mod_id
    end
    # Check if there is an existing tuple for this pair
    existing_log = PathwaySearchLog.select{|log| log.first_mod_id == mod_a && log.second_mod_id == mod_b && log.course_id == course_id && log.created_at.to_date == Time.now.to_date}
    if existing_log.size > 0
      desired_log = existing_log.first
      desired_log.update_attribute("counter", desired_log.counter + 1)
    else
      # Create a new tuple if one does not exist
      PathwaySearchLog.create(:first_mod_id => mod_a, :second_mod_id => mod_b, :counter => 1)
    end

end
