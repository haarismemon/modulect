module Admin::UploadModulesHelper

  MULTI_ITEM_FIELD_SEPARATOR = ';'

  def upload_uni_module(new_record)
    # Lookup if Module already exists: Module is unique by Code
    csv_module = UniModule.find_by_code(new_record['code'])

    creations = 0
    updates = 0

    if csv_module.nil?
      csv_module = try_to_create_module(new_record)
      creations += 1
    else
      csv_module = try_to_update_module(new_record)
      updates += 1
    end

    should_save = check_module_errors(csv_module)

    if should_save
      csv_module.save
    end

    return creations, updates
  end

  private
  def try_to_create_module(new_record)
    created_module = UniModule.new(new_record.except(
        'departments',
        'prerequisite_modules',
        'career_tags',
        'interest_tags'))

    update_departments(created_module, new_record)
    update_prerequisite_modules(created_module, new_record)
    update_career_tags(created_module, new_record)
    update_interest_tags(created_module, new_record)

    created_module
  end

  def try_to_update_module(new_record)
    updated_module = UniModule.find_by_code(new_record['code'])

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

  def update_departments(created_module, new_record)
    created_module.departments.clear
    uploaded_departments = new_record['departments']
    unless uploaded_departments.nil?
      uploaded_departments = uploaded_departments.split(MULTI_ITEM_FIELD_SEPARATOR)
      if current_user.user_level == 'department_admin_access'
        user_dept = Department.find(current_user.department_id).name
        if uploaded_departments.include? user_dept
          uploaded_departments.each do |dept|
            chosen_dept = Department.find_by_name(dept)
            created_module.departments << chosen_dept
          end
        end
      end
    end
  end

  def update_prerequisite_modules(created_module, new_record)
    created_module.uni_modules.clear
    uploaded_prerequisites = new_record['prerequisite_modules']
    unless uploaded_prerequisites.nil?
      uploaded_prerequisites = uploaded_prerequisites.split(MULTI_ITEM_FIELD_SEPARATOR)
      if !uploaded_prerequisites.include? created_module.name
        uploaded_prerequisites.each do |mod|
          chosen_mod = UniModule.find_by_name(mod)
          created_module.uni_modules << chosen_mod
        end
      end
    end
  end

  def update_career_tags(created_module, new_record)
    created_module.tags.clear
    uploaded_career_tags = new_record['career_tags']
    unless uploaded_career_tags.blank?
      uploaded_career_tags = uploaded_career_tags.split(MULTI_ITEM_FIELD_SEPARATOR)
      uploaded_career_tags.each do |tag|
        chosen_tag = Tag.find_by_name(tag)
        if chosen_tag.present?
          created_module.tags << chosen_tag
        else
          new_tag = Tag.new(name: tag, type: 'CareerTag')
          created_module.tags << new_tag
        end
      end
    end
  end


  def update_interest_tags(created_module, new_record)
    created_module.interest_tags.clear
    uploaded_interest_tags = new_record['interest_tags']
    unless uploaded_interest_tags.blank?
      uploaded_interest_tags = uploaded_interest_tags.split(MULTI_ITEM_FIELD_SEPARATOR)
      uploaded_interest_tags.each do |tag|
        chosen_tag = Tag.find_by_name(tag)
        if chosen_tag.present?
          created_module.tags << chosen_tag
        else
          new_tag = Tag.new(name: tag, type: 'InterestTag')
          created_module.tags << new_tag
        end
      end
    end
  end

  def check_module_errors(csv_module)
    valid_module = false
    if valid_base_attributes?(csv_module) && valid_associations?(csv_module)
      valid_module = true
    else
      display_errors csv_module
    end

    valid_module
  end

  def valid_base_attributes?(record)
    record.valid?
  end

  def valid_associations?(csv_module)
    valid_module = true
    if csv_module.tags.empty?
      csv_module.errors[:base] << "At least a Tag must be given"
      valid_module = false
    elsif csv_module.departments.empty?
      csv_module.errors[:base] << "At least a Department must be given"
      valid_module = false
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
end
