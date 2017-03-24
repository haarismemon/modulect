module Admin::UploadModulesHelper

  include Admin::MultiItemFieldHelper

  def upload_uni_module(new_record)
    creations = 0
    updates = 0

    csv_module = find_module_by_code(new_record['code'])

    if dept_admin_invalid_create(csv_module, new_record)
      flash[:error] = "Failed to create module #{new_record['code']}: Module not linked to your department"
    elsif dept_admin_invalid_update(csv_module, new_record)
      flash[:error] = "Failed to update module #{new_record['code']}: Module not linked to your department"
    else
      # All validation checks passed
      new_record['semester'] = convert_semester_to_enum(new_record['semester'])

      if csv_module.nil?
        csv_module = try_to_create_module(new_record)
        creations += 1
      else
        csv_module = try_to_update_module(csv_module, new_record)
        updates += 1
      end

      if should_save?(csv_module)
        csv_module.save
      else
        display_errors csv_module
      end
    end

    return creations, updates
  end

  private
  def dept_admin_invalid_update(csv_module, new_record)
    # Prevent updating modules not in their department and prevent un-linking their own dept from module
    is_not_super_admin && being_updated?(csv_module) && (!csv_module.departments.include?(current_user.department) || !new_record['departments'].include?(current_user.department.name))
  end

  def dept_admin_invalid_create(csv_module, new_record)
    # Prevent creating modules that don't belong to their department
    is_not_super_admin && !being_updated?(csv_module) && !new_record['departments'].include?(current_user.department.name)
  end

  def try_to_create_module(new_record)
    new_module = UniModule.new(new_record.except(
        'departments',
        'prerequisite_modules',
        'career_tags',
        'interest_tags'))

    update_departments(new_module, new_record)
    update_prerequisite_modules(new_module, new_record)
    update_career_tags(new_module, new_record)
    update_interest_tags(new_module, new_record)

    new_module
  end

  def try_to_update_module(updated_module, new_record)
    updated_module.assign_attributes(new_record.except(
        'departments',
        'prerequisite_modules',
        'career_tags',
        'interest_tags'))

    update_departments(updated_module, new_record)
    update_prerequisite_modules(updated_module, new_record)
    update_career_tags(updated_module, new_record)
    update_interest_tags(updated_module, new_record)

    updated_module
  end

  def update_departments(uni_module, new_record)
    uni_module.departments.clear
    uploaded_department_names = split_multi_association_field(new_record['departments'])
    unless uploaded_department_names.blank?
      if current_user.user_level == 'department_admin_access'
        user_dept = Department.find(current_user.department_id).name
        if uploaded_department_names.include? user_dept
          uploaded_department_names.each do |dept_name|
            chosen_dept = find_department_by_name(dept_name)
            uni_module.departments << chosen_dept
          end
        end
      end
    end
  end

  def update_prerequisite_modules(uni_module, new_record)
    uni_module.uni_modules.clear
    prerequisite_codes = split_multi_association_field(new_record['prerequisite_modules'])
    unless prerequisite_codes.blank?
      unless prerequisite_codes.include? uni_module.name
        prerequisite_codes.each do |prerequisite_code|
          chosen_mod = find_module_by_code(prerequisite_code)
          if !chosen_mod.blank?
            uni_module.uni_modules << chosen_mod
          else
            uni_module.errors[:base] << "Could not find module by code: #{prerequisite_code}"
          end
        end
      end
    end
  end

  def update_career_tags(uni_module, new_record)
    uni_module.tags.clear
    uploaded_career_tags = split_multi_association_field(new_record['career_tags'])
    unless uploaded_career_tags.blank?
      uploaded_career_tags.each do |tag_name|
        chosen_tag = find_tag_by_name(tag_name)
        if chosen_tag.present?
          uni_module.tags << chosen_tag
        else
          new_tag = Tag.new(name: tag_name, type: 'CareerTag')
          uni_module.tags << new_tag
        end
      end
    end
  end

  def update_interest_tags(uni_module, new_record)
    uni_module.interest_tags.clear
    uploaded_interest_tags = split_multi_association_field(new_record['interest_tags'])
    unless uploaded_interest_tags.blank?
      uploaded_interest_tags.each do |tag_name|
        chosen_tag = find_tag_by_name(tag_name)
        if chosen_tag.present?
          uni_module.tags << chosen_tag
        else
          new_tag = Tag.new(name: tag_name, type: 'InterestTag')
          uni_module.tags << new_tag
        end
      end
    end
  end

  def should_save?(csv_module)
    !invalid_module?(csv_module)
  end

# Calling csv_module#valid? will override the already existent errors.
# Make sure that valid_base_attributes? is called last so no errors are overridden.
  def invalid_module?(csv_module)
    !csv_module.errors.empty? || !valid_associations?(csv_module) || !valid_base_attributes?(csv_module)
  end

  def valid_base_attributes?(record)
    record.valid?
  end

  def valid_associations?(csv_module)
    valid_module = false
    if csv_module.tags.empty?
      csv_module.errors[:base] << "At least a Tag must be given"
    elsif csv_module.departments.empty?
      csv_module.errors[:base] << "At least a Department must be given"
    else
      valid_module = true
    end

    valid_module
  end

  def display_errors(csv_module)
    update_error = "Update Failed: "
    csv_module.errors.full_messages.each do |error|
      update_error += error + '; '
    end
    flash[:error] = update_error
  end

  def find_department_by_name(name)
    Department.find_by_name(name)
  end

  def find_module_by_code(code)
    UniModule.find_by_code(code)
  end

  def find_tag_by_name(name)
    Tag.find_by_name(name)
  end

  def convert_semester_to_enum(semester)
    case semester
      when '1 or 2'
        0
      when '1'
        1
      when '2'
        2
      else
        3
    end
  end

  def being_updated?(the_module)
    !the_module.nil?
  end

  def is_not_super_admin
    current_user.user_level != 'super_admin_access'
  end
end
