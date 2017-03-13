module CoursesHelper
  def deep_clone_courses_with_ids(ids_to_clone_as_strings)
    course_ids = eval(ids_to_clone_as_strings)

    course_ids.each do |id|
       course = Course.find(id.to_i)
      
        if !course.nil?
          cloned = clone_course(course)

          Department.all.each do |department|
            if department.courses.include?(course)
              department.courses << cloned
            end
          end

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

  private
  def clone_course(course)
    cloned_course = course.dup
    cloned_course.update_attribute("name", course.name + "-CLONE")
    cloned_course.save

    cloned_course
  end
end
