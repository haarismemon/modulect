require 'timeout'
require 'rails_helper'
require 'support/login_helper'
require 'support/courses_index_steps'

feature "Admin courses index page actions - ", :js => true do
  include LoginHelper
  include CoursesIndexSteps

  given! (:admin) { create(:user, user_level: "super_admin_access") }
  given! (:course) { create(:course) }

  before do
    visit admin_courses_path
    login_user(admin, 'password')
  end

  scenario "can clone a course" do
    select_first_course
    select_clone_action
    confirm_action
    i_should_see_a_clone_of(course)
  end

  scenario "can delete a course" do
    find("#check_individual[value='1']").set(true)
    find("#bulk-actions").click
    find("#delete-all").click
    confirm_action
    expect(page).not_to have_content("#{course.name}")
    expect(page).to have_current_path(admin_courses_path)
  end
end
