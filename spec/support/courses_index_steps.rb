require 'support/wait_for_ajax'

module CoursesIndexSteps
  def select_first_course
    find("#check_individual[value='1']").set(true)
  end
  
  def select_clone_action
    find("#bulk-actions").click
    find("#clone-all").click
  end

  def i_should_see_a_clone_of(course)
    expect(page).to have_content("#{course.name}-CLONE")
  end

  def confirm_action
    wait_for_ajax
    click_button("Proceed")
    click_button("OK")
  end
end
