require 'support/wait_for_ajax'
require 'support/selectize_select'
require 'support/course_form_filler'

module CoursesIndexSteps
  include SelectizeSelect
  include CourseFormFiller
  include WaitForAjax

  def select_first_course
    find("#check_individual[value='1']").set(true)
  end

  def select_clone_action
    find("#bulk-actions").click
    find("#clone-all").click
  end

  def select_edit_action
    find(".action-edit").click
  end

  def click_update_button
    click_button "Update"
  end

  def select_delete_action
    find("#bulk-actions").click
    find("#delete-all").click
  end

  def confirm_action
    wait_for_ajax
    click_button("Proceed")
    click_button("OK")
  end

  def i_should_be_back_on_the_index_page
    expect(page).to have_current_path(admin_courses_path)
  end

  def i_should_see_a_clone_of(course)
    expect(page).to have_content("#{course.name}-CLONE")
  end

  def i_should_see_the_name_of_the_new_course
    assert_text Course.last.name
  end

  def i_should_be_on_the_edit_page_of_the_new_course
    expect(page).to have_current_path(edit_admin_course_path(Course.last))
  end

  def i_should_not_see(course)
    expect(page).not_to have_content("#{course.name}")
  end
end

