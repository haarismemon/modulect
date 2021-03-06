require 'support/selectize_select'

module CourseFormFiller
  include SelectizeSelect

  def fill_in_course_form(department)
    selectize_select(department.name)
    fill_in "course_name", with: 'New Course'
    fill_in "course_year", with: '2015'
  end
end
