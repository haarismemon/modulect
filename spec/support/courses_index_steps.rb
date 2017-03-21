require 'support/course_form_filler'
require 'support/bulk_actions_steps'

module CoursesIndexSteps
  include CourseFormFiller
  include BulkActionsSteps

  def select_edit_action
    find(".action-edit").click
  end

  def click_update_button
    click_button "Update"
  end

  def click_delete_link
    click_on "Delete"
  end

  def i_should_be_on_the_courses_index_page
    expect(page).to have_current_path(admin_courses_path)
  end

  def i_should_see_a_clone_of(course)
    expect(page).to have_content("#{course.to_s}-CLONE")
  end

  def i_should_see_the_name_of_the_new_course
    assert_text Course.last.to_s
  end

  def i_should_see_an_update_success_flash
    assert_text "updated"
  end

  def i_should_be_on_the_edit_page_of_the_new_course
    expect(page).to have_current_path(edit_admin_course_path(Course.last))
  end

  def i_should_not_see(course)
    expect(page).not_to have_content(course.to_s)
  end
end

