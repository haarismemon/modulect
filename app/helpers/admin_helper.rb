module AdminHelper

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

  def get_num_courses_for_department(valid_department)
    valid_department.courses.size
  end

  def get_num_depts_for_faculty(valid_faculty)
    count = 0

    Department.all.each do |department|
      if department.faculty_id == valid_faculty.id
        count+= 1
      end
    end

    count
  end

  def get_num_departments_for_course(valid_course)
    count = 0
    Department.all.each do |department|
      if department.courses.include?(valid_course)
        count+= 1
      end
    end

    if count == 1 
      count.to_s + " Department"
    else 
      count.to_s + "Departments"
    end
  end

  def has_linked_tags(valid_module)
    if valid_module.tags.size > 0
      true
    else
      false
    end
  end

end
