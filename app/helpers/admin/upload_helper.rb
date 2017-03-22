module Admin::UploadHelper
  include UploadModulesHelper
  # include MultiItemFieldHelper
  #
  # def upload_course(new_record)
  #   creations = 0
  #   updates = 0
  #
  #   csv_course = find_course_from_database(new_record)
  #   if csv_course.nil?
  #     csv_course = try_to_create_course(new_record)
  #     creations += 1
  #   else
  #     csv_course = try_to_update_course(new_record)
  #     updates += 1
  #   end
  #
  #   update_departments(csv_course, new_record)
  #
  #   should_save = check_course_errors(csv_course)
  #
  #   if should_save
  #     csv_course.save
  #   end
  #
  #   unless course_verification_failed
  #     # For every entered department
  #     uploaded_departments = split_multi_association_field(new_record['departments'])
  #     uploaded_departments.each do |dept_name|
  #       # Look for a department with the name
  #       department_found = Department.find_by_name(dept_name)
  #       if department_found.nil?
  #         flash[:error] = "Department with name: #{dept_name} does not exist and therefore has not
  #                                       been linked to Course: #{new_record['name']}, #{new_record['year']}"
  #       else
  #         # Add the found department to the departments the course belongs to
  #         csv_course.departments << department_found
  #       end
  #     end
  #   end
  #
  #   return creations, updates
  # end
  #
  # private
  # def try_to_update_course(new_record)
  #   updated_course = find_course_from_database(new_record)
  #
  #   updated_course.assign_attributes(new_record.except('departments'))
  #   new_record.except('departments')
  # end
  #
  # def try_to_create_course(new_record)
  #   new_course = Course.new(new_record.except('departments'))
  #
  #   update_departments(new_course, new_record)
  #
  #   new_course
  # end
  #
  # def update_departments(course, new_record)
  #   course.departments.clear
  #   uploaded_departments = split_multi_association_field(['departments'])
  #   unless uploaded_departments.blank?
  #
  #   end
  # end
  #
  # def find_course_from_database(new_record)
  #   Course.find_by(name: new_record['name'], year: new_record['year'])
  # end
end
