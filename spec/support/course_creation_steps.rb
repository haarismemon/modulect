require 'support/selectize_select'
require 'support/course_form_filler'

module CourseCreationSteps
  include CourseFormFiller
  include SelectizeSelect

  def select_new_course_action
    find("#new-course").click
  end

  def create_new_course_belonging_to(department)
    select_new_course_action
    i_should_be_on_the_create_a_new_course_page
    fill_in_course_form(department)
    click_button "New Course"
  end

  def define_a_module_group_for_each_year_structure(uni_modules_to_include)
    for i in 1 .. Course.last.year_structures.count
      find("#modify-#{i}").click
      click_add_module_group
      wait_for_ajax
      fill_in_new_group_form(uni_modules_to_include)
      click_button "Update"
      i_should_be_on_the_edit_page_of_the_new_course
    end
  end

  def click_add_module_group
    find('.add_fields').click
  end

  def fill_in_new_group_form(uni_modules_to_include = [])
    fill_in("Name Of Group", with: "Semester 1")
    fill_in("Minimum Possible Credits For This Group", with: 60)
    fill_in("Maximum Possible Credits For This Group", with: 60)
    # uni_modules_to_include.each do |uni_module|
    #   selectize_select(uni_module.to_s)
    # end
  end

  def i_should_be_on_the_create_a_new_course_page
    expect(page).to have_current_path(new_admin_course_path)
  end

  def i_should_be_on_the_edit_page_of_the_new_course
    expect(page).to have_current_path(edit_admin_course_path(Course.last))
  end
end

