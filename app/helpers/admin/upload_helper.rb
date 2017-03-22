module Admin::UploadHelper
  def parse_mult_association_string(mult_assoc_string)
    if mult_assoc_string.nil?
      ['']
    else
      mult_assoc_string.gsub('; ', ';').split(';')
    end
  end

  def upload_uni_module(new_record)
    # Add departments attribute to create and/or link departments to this module
    # Track if module failed to be created
    module_verification_failed = false
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
      flash[:error] = created_module.errors.full_messages
      return
    end

    new_module_departments = new_record['departments']
    logger.debug("ASJDHLKJHADKLJFHAIDKHFKAJDHF")
    logger.debug(new_record['departments'])
    unless new_module_departments.nil?
      new_module_departments = new_module_departments.split(';')

      if current_user.user_level == "department_admin_access"
        user_dept = Department.find(current_user.department_id).name
        if !(new_module_departments.include? user_dept)
          # If user does not include their own department in the department list.
          created_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
          return
        end
      end
      new_module_departments.each do |dept|
        chosen_dept = Department.find_by_name(dept)
        created_module.departments << chosen_dept
      end
    end

    prerequisite_modules = new_record['prerequisite_modules']
    unless prerequisite_modules.nil?
      prerequisite_modules = prerequisite_modules.split(';')

      if prerequisite_modules.include? created_module.name
        created_module.errors[:base] << "A module cannot be a prerequisite of itself."
        return
      end
      prerequisite_modules.each do |mod|
        chosen_mod = UniModule.find_by_name(mod)
        created_module.uni_modules << chosen_mod
      end
    end
  end

  def update_existing_module(new_record)
    # Update the existing Module
    UniModule.update(new_record.except(
        'departments',
        'prerequisite_modules',
        'career_tags',
        'interest_tags'))

    created_module = UniModule.find_by_code(new_record['code'])

    created_module.departments.clear()
    new_module_departments = new_record['departments']
    logger.debug("ASJDHLKJHADKLJFHAIDKHFKAJDHF")
    logger.debug(new_record[:departments])
    unless new_module_departments.nil?
      new_module_departments = new_module_departments.split(';')
      if current_user.user_level == "department_admin_access"
        user_dept = Department.find(current_user.department_id).name
        if !(new_module_departments.include? user_dept)
          # If user does not include their own department in the department list.
          created_module.errors[:base] << "Module must also belong to your department (#{user_dept})."
          return
        end
      end
      new_module_departments.each do |dept|
        chosen_dept = Department.find_by_name(dept)
        created_module.departments << chosen_dept
      end
    end

    created_module.uni_modules.clear()
    prerequisite_modules = new_record['prerequisite_modules']
    unless prerequisite_modules.nil?
      prerequisite_modules = prerequisite_modules.split(';')
      if prerequisite_modules.include? created_module.name
        created_module.errors[:base] << "A module cannot be a prerequisite of itself."
        return
      end
      prerequisite_modules.each do |mod|
        chosen_mod = UniModule.find_by_name(mod)
        created_module.uni_modules << chosen_mod
      end
    end

    created_module.tags.clear()
    career_tags = new_record['career_tags']
    unless career_tags.nil?
      career_tags = career_tags.split(';')
      career_tags.each do |tag|
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

    interest_tags = new_record['interest_tags']
    unless interest_tags.nil?
      interest_tags = interest_tags.split(',')
      interest_tags.each do |tag|
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
