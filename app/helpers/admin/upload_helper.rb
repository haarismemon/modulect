module Admin::UploadHelper
  def parse_mult_association_string(mult_assoc_string)
    if mult_assoc_string.nil?
      ['']
    else
      mult_assoc_string.gsub('; ', ';').split(';')
    end
  end

  def upload_uni_module(new_record)
    # Lookup if Module already exists: Module is unique by Code
    created_module = UniModule.find_by_code(new_record['code'])

    creations = 0
    updates = 0

    if created_module.nil?
      create_new_module(new_record)
      creations += 1
    else
      update_existing_module(new_record)
      updates += 1
    end
    return creations, updates
  end

  private
  def create_new_module(new_record)
    created_module = UniModule.create(new_record.except(
        'departments',
        'prerequisite_modules',
        'career_tags',
        'interest_tags'))

    if created_module.new_record?
      creation_error = String.new
      created_module.errors.full_messages.each do |message|
        creation_error += message + '; '
      end
      flash[:error] = creation_error
      return
    end

    update_departments(created_module, new_record)
    update_prerequisite_modules(created_module, new_record)
    update_career_tags(created_module, new_record)
    update_interest_tags(created_module, new_record)
  end

  def update_existing_module(new_record)

    updated_module = UniModule.find_by_code(new_record['code'])

    updated_module.assign_attributes(new_record.except(
                  'departments',
                  'prerequisite_modules',
                  'career_tags',
                  'interest_tags'))

    unless updated_module.valid?
      update_error = "Update Failed: "
      debugger
      updated_module.errors.full_messages.each do |message|
        update_error += message + '; '
      end
      flash[:error] = update_error
      return
    end

    update_departments(updated_module, new_record)
    update_prerequisite_modules(updated_module, new_record)
    update_career_tags(updated_module, new_record)
    update_interest_tags(updated_module, new_record)
  end

  def update_prerequisite_modules(created_module, new_record)
    created_module.uni_modules.clear unless created_module.uni_modules.blank?
    uploaded_prerequisites = new_record['prerequisite_modules']
    unless uploaded_prerequisites.nil?
      uploaded_prerequisites = uploaded_prerequisites.split(';')
      if !uploaded_prerequisites.include? created_module.name
        uploaded_prerequisites.each do |mod|
          chosen_mod = UniModule.find_by_name(mod)
          created_module.uni_modules << chosen_mod
        end
      else
        created_module.errors[:base] << 'A module cannot be a prerequisite of itself.'
      end
    end
  end

  def update_career_tags(created_module, new_record)
    created_module.tags.clear unless created_module.tags.blank?
    uploaded_career_tags = new_record['career_tags']
    unless uploaded_career_tags.nil?
      uploaded_career_tags = uploaded_career_tags.split(';')
      uploaded_career_tags.each do |tag|
        chosen_tag = Tag.find_by_name(tag)
        # Add the career tag association
        if chosen_tag.present?
          created_module.tags << chosen_tag
        else
          # If tag does not already exist then create a new tag
          new_tag = Tag.new(name: tag, type: 'CareerTag')
          created_module.tags << new_tag
        end
      end
    end
  end

  def update_departments(created_module, new_record)
    created_module.departments.clear unless created_module.departments.blank?
    uploaded_departments = new_record['departments']
    unless uploaded_departments.nil?
      uploaded_departments = uploaded_departments.split(';')
      if current_user.user_level == 'department_admin_access'
        user_dept = Department.find(current_user.department_id).name
        if uploaded_departments.include? user_dept
          uploaded_departments.each do |dept|
            chosen_dept = Department.find_by_name(dept)
            created_module.departments << chosen_dept
          end
        else
          created_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
        end
      end
    end
  end

  def update_interest_tags(created_module, new_record)
    created_module.interest_tags.clear unless created_module.interest_tags.blank?
    uploaded_interest_tags = new_record['interest_tags']
    unless uploaded_interest_tags.nil?
      uploaded_interest_tags = uploaded_interest_tags.split(',')
      uploaded_interest_tags.each do |tag|
        chosen_tag = Tag.find_by_name(tag)
        # Add the interest tag association
        if chosen_tag.present?
          created_module.tags << chosen_tag
        else
          # If tag does not already exist then create a new tag
          new_tag = Tag.new(name: tag, type: 'InterestTag')
          created_module.tags << new_tag
        end
      end
    end
  end
end
