module UsersHelper
  # Returns the full name for an user.
  def full_name_for(user)
    "#{user.first_name} #{user.last_name}"
  end

  # Returns the string representation of an user's privilege level.
  def privileges_description_for(user)
    case user.user_level
    when 3
      "Student"
    when 2
      "Department Administrator"
    when 1
      "System Administrator"
    end
  end

  # Returns an array containing all departments in a specified faculty
  def departments_of(faculty)
    @depts = Department.pluck(faculty)
  end

  # Returns an array containing all courses in a specified department
  def courses_of(department) 
    @course = Course.pluck(department)
  end

end
