module Admin::UploadHelper
  include Admin::MultiItemFieldHelper
  include UploadModulesHelper
  include UploadCoursesHelper

  def upload_uni_modules(parsed_csv)
    creations, updates = 0, 0
    parsed_csv.each do |row|
      new_record = row.to_hash
      new_creations, new_updates = upload_uni_module(new_record)
      creations += new_creations
      updates += new_updates
    end
    return creations,updates
  end

  def upload_courses(parsed_csv)
    creations, updates = 0, 0
    parsed_csv.each do |row|
      new_record = row.to_hash
      new_creations, new_updates = upload_course(new_record)
      creations += new_creations
      updates += new_updates
    end
    return creations, updates
  end

  def upload_faculties(parsed_csv)
    creations, updates = 0, 0
    parsed_csv.each do |row|
      csv_faculty = row.to_hash
      if csv_faculty['name'].nil?
        flash[:error] = 'Creation failed: Name cannot be left blank'
      else
        if Faculty.find_by_name(csv_faculty['name']).nil?
          faculty_entry = Faculty.create(csv_faculty.except('departments'))
          creations += 1
        else
          faculty_entry = Faculty.find_by_name(csv_faculty['name'])
          updates += 1
        end
        faculty_entry.departments= []
        split_multi_association_field(csv_faculty['departments']).each do |dept_name|
          department_found = Department.find_by_name(dept_name)
          if department_found.nil?
            Department.create(name: dept_name, faculty_id: faculty_entry.id)
          else
            department_found.update(faculty_id: faculty_entry.id)
          end
        end
      end
    end
    return creations, updates
  end

  def upload_departments(parsed_csv)
    creations, updates = 0, 0
    parsed_csv.each do |row|
      csv_department = row.to_hash
      if Faculty.where(name: row.to_hash['faculty_name']).first.nil?
        flash[:error] = "No Faculty with name: #{row.to_hash['faculty_name']} found.
                              Department with name: #{row.to_hash['name']} has not been created"
      else
        csv_department['faculty_id'] = Faculty.where(name: row.to_hash['faculty_name']).first.id
        csv_department = csv_department.except('faculty_name')
        if Department.find_by_name(csv_department['name']).nil?
          Department.create(csv_department).errors.full_messages.each { |message| flash[:error] = "Creation failed: #{message}" }
          creations += 1
        else
          Department.update(csv_department)
          updates += 1
        end
      end
    end
    return creations, updates
  end
end
