module Admin::UploadHelper
  include Admin::MultiItemFieldHelper
  include UploadModulesHelper
  include UploadCoursesHelper

  def parse_csv_and_display_notice(csv_text)
    # Replace characters not defined by utf-8
    csv_text = csv_text.encode(invalid: :replace, undef: :replace, replace: '')
    parsed_csv = CSV.parse(csv_text, headers: true)
    # Retrieve the header of the uploaded CSV to determine if valid
    uploaded_header = parsed_csv.headers

    if parsed_csv.length == 0
      flash[:error] = 'Upload Failed: No records found. CSV is empty'
    elsif uploaded_header != session[:resource_header]
      # In this case the user didn't upload the resource the server was expecting
      flash[:error] = 'Upload Failed: Please ensure the CSV header matches the template file'
    else
      # Depending on the resource, call the appropriate upload method
      # And retrieve the number of creations and updates that were made
      if session[:resource_name] == 'departments'
        creations, updates = upload_departments(parsed_csv)
      elsif session[:resource_name] == 'faculties'
        creations, updates = upload_faculties(parsed_csv)
      elsif session[:resource_name] == 'courses'
        creations, updates = upload_courses(parsed_csv)
      elsif session[:resource_name] == 'uni_modules'
        creations, updates = upload_uni_modules(parsed_csv)
      else
        flash[:notice] = 'Resource not recognized'
        creations, updates = 0, 0
      end
      flash[:success] = "Upload complete: Attempted #{creations} creations, #{updates} updates"
    end
  end

  def upload_departments(parsed_csv)
    creations, updates = 0, 0
    parsed_csv.each do |row|
      csv_department = row.to_hash
      # If a department is found to be linked to a Faulty that doesn't exist
      if Faculty.where(name: row.to_hash['faculty_name']).first.nil?
        flash[:error] = "No Faculty with name: #{row.to_hash['faculty_name']} found.
                              Department with name: #{row.to_hash['name']} has not been created"
      else
        # Add the faculty ID from name to the hash, exclude the faculty name from the hash
        # The hash now includes all the required attributes for create/update
        csv_department['faculty_id'] = Faculty.where(name: row.to_hash['faculty_name']).first.id
        csv_department = csv_department.except('faculty_name')
        if Department.find_by_name(csv_department['name']).nil?
          # If department doesn't exist -> create
          Department.create(csv_department).errors.full_messages.each { |message| flash[:error] = "Creation failed: #{message}" }
          creations += 1
        else
          # If department doesn't exist -> update
          Department.update(csv_department)
          updates += 1
        end
      end
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
        # If faculty doesn't exist -> create
        if Faculty.find_by_name(csv_faculty['name']).nil?
          faculty_entry = Faculty.create(csv_faculty.except('departments'))
          creations += 1
        else
          # If faculty doesn't exist then find existing faculty object
          faculty_entry = Faculty.find_by_name(csv_faculty['name'])
          updates += 1
        end
        # This will happen on both create and update
        faculty_entry.departments= []
        split_multi_association_field(csv_faculty['departments']).each do |dept_name|
          department_found = Department.find_by_name(dept_name)
          if department_found.nil?
            # If department entered doesn't already exist, create new dept with faculty as this faculty
            Department.create(name: dept_name, faculty_id: faculty_entry.id)
          else
            # If department exists, update faculty id of found dept to this faculty
            department_found.update(faculty_id: faculty_entry.id)
          end
        end
      end
    end
    return creations, updates
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
end
