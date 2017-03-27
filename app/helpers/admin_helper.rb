module AdminHelper
  include SessionsHelper

  # A simple helper method which sets the page title on admin
  def full_title_admin(page_title = '')
      base_title = "Modulect"
      if page_title.empty?
       "Admin | " + base_title
      else
        page_title + " - Admin | " + base_title
      end
  end

    # sort_by is like "name" for unimodule
    # order is either asc or desc (lowercase)
    def sort(table_name, list, sort_by, order, per_page, default)

      if table_name.has_attribute?(sort_by) && (order == "asc" || order == "desc")
       list = list.sort_by{|item| item[sort_by].to_s.downcase}
        if order == "desc"
          list = list.reverse
        end
        list 
      else
        # default case
        list.sort_by{|item| item[default].downcase}
      end

    end 

    # returns the number of courses for a department
    def get_num_courses_for_department(valid_department)
      valid_department.courses.count
    end

    # returns the number of departments for a faculty
    def get_num_depts_for_faculty(valid_faculty)
      valid_faculty.departments.count
    end

    # gets number of departments for a course
    def get_num_departments_for_course(valid_course)
      count = valid_course.departments.count
     "#{count} #{'Department'.pluralize(count)}"
    end

    def has_linked_tags(valid_module)
      valid_module.tags.any?
    end

    # As a department admin, a group can be made out of modules
    # that only belong to that admin's managed departments.
    # Super admins can add any module.
    def possible_uni_modules_for_new_group(calling_user = current_user)
      if (calling_user.department_admin?)
        calling_user.department.uni_modules
      else
        UniModule.all
      end
    end
    
    # returns the possible uni modules which can be in the group
    def possible_uni_modules_for_existing_group(year_structure)
      to_return = []

      year_structure.course.departments.each do |department|
        department.uni_modules.each do |uni_module|
          to_return << uni_module if !to_return.include?(uni_module)
        end
      end
      to_return
    end
end
