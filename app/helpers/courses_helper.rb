module CoursesHelper

  # handles the deep cloning of the course (year structures and groups included). if a clone already exists with the same year, a flash error is shown
  def deep_clone_courses_with_ids(ids_to_clone_as_strings)
    course_ids = eval(ids_to_clone_as_strings)

    course_ids.each do |id|
       course = Course.find(id.to_i)
      
        if !course.nil?
          if Course.where(name: course.name + "-CLONE", year: course.year).exists?
              flash[:error] = "Some records have already been cloned and cannot be recloned."
          else

            cloned = clone_course(course)

            # adding new clone to the departments
            Department.all.each do |department|
              if department.courses.include?(course)
                department.courses << cloned
              end
            end

            # cloning the year structures and groups
            course.year_structures.each do |year_structure|
              cloned_year_structure = year_structure.dup
              cloned.year_structures << cloned_year_structure

              year_structure.groups.each do |group|
                cloned_group = group.dup
                cloned_year_structure.groups << cloned_group

                group.uni_modules.each do |uni_module|
                  cloned_group.uni_modules << uni_module
                end
              end
            end
          end
        end
     end
  end

  private
  # clones an individual course with no deep cloning
  def clone_course(course)
    cloned_course = course.dup
    cloned_course.update_attribute("name", course.name + "-CLONE")
    cloned_course.save

    cloned_course
  end
end
