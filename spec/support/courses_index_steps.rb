require 'support/wait_for_ajax'

module CoursesIndexSteps
  def select_first_course
    find("#check_individual[value='1']").set(true)
  end
  
  def select_clone_action
    find("#bulk-actions").click
    find("#clone-all").click
  end

  def select_delete_action
    find("#bulk-actions").click
    find("#delete-all").click
  end

  def select_new_course_action
    find("#new-course").click
  end

  def confirm_action
    wait_for_ajax
    click_button("Proceed")
    click_button("OK")
  end

  def i_should_be_back_on_the_index_page
    expect(page).to have_current_path(admin_courses_path)
  end

  def i_should_be_on_the_create_a_new_course_page
    expect(page).to have_current_path(new_admin_course_path)
  end

  def i_should_see_a_clone_of(course)
    expect(page).to have_content("#{course.name}-CLONE")
  end

  def i_should_not_see(course)
    expect(page).not_to have_content("#{course.name}")
  end
end

