module Admin::UploadCoursesHelper

  include Admin::MultiItemFieldHelper

  def upload_course(new_record)
    creations = 0
    updates = 0

    csv_course = find_course_from_database(new_record)
    if csv_course.blank?
      csv_course = try_to_create_course(new_record)
      creations += 1
    else
      csv_course = try_to_update_course(csv_course, new_record)
      updates += 1
    end

    update_departments(csv_course, new_record)

    if should_save?(csv_course)
      csv_course.save
    else
      display_errors csv_course
    end

    return creations, updates
  end

  private
  def try_to_create_course(new_record)
    new_course = Course.new(new_record.except('departments'))
    update_departments(new_course, new_record)
    new_course
  end

  def try_to_update_course(updated_course, new_record)
    updated_course.assign_attributes(new_record.except('departments'))
    update_departments(updated_course, new_record)
    updated_course
  end

  def update_departments(csv_course, new_record)
    csv_course.departments.clear
    uploaded_departments = split_multi_association_field(new_record['departments'])
    uploaded_departments.each do |dept_name|
      found_department = find_department_by_name dept_name
      if !found_department.blank?
        csv_course.departments << found_department
      else
        csv_course.errors[:base] << "Department not found: #{dept_name}"
      end
    end
  end

  def should_save?(csv_course)
    !invalid_course?(csv_course)
  end

  def invalid_course?(csv_course)
    !csv_course.errors.empty? || !valid_associations?(csv_course) || !valid_base_attributes?(csv_course)
  end

  def valid_associations?(csv_course)
    valid_course = false
    if csv_course.departments.empty?
      csv_course.errors[:base] << 'At least a Department must be given'
    else
      valid_course = true
    end

    valid_course
  end

  def display_errors(csv_course)
    update_error = "Update Failed: "
    csv_course.errors.full_messages.each do |error|
      update_error += error + '; '
    end
    flash[:error] = update_error
  end

  def valid_base_attributes?(csv_course)
    csv_course.valid?
  end

  def find_department_by_name(name)
    Department.find_by_name(name)
  end

  def find_course_from_database(new_record)
    Course.find_by(name: new_record['name'], year: new_record['year'])
  end
end
