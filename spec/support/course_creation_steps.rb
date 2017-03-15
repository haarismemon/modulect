require 'support/selectize_select'
require 'support/course_form_filler'

module CourseCreationSteps
  include CourseFormFiller

  def select_new_course_action
    find("#new-course").click
  end

  def fill_in_new_group_form
    fill_in("Name", with: "Semester 1")
    fill_in("Total credits", with: 60)
    selectize_select(uni_module.to_s)
  end

  def i_should_be_on_the_create_a_new_course_page
    expect(page).to have_current_path(new_admin_course_path)
  end

  def i_should_be_on_the_edit_page_of_the_new_course
    expect(page).to have_current_path(edit_admin_course_path(Course.last))
  end
end
