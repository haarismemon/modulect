require 'timeout'
require 'rails_helper'
require 'support/login_helper'
require 'support/courses_index_steps'

feature "Index page of courses: admin ", :js => true do
  include LoginHelper
  include CoursesIndexSteps

  given! (:admin) { create(:user, user_level: "super_admin_access") }
  given! (:course) { create(:course) }
  given (:department) { create(:department) }

  before do
    visit admin_courses_path
    login_user(admin, "password")
  end

  scenario "can clone a course" do
    select_first_course
    select_clone_action
    confirm_action
    i_should_be_back_on_the_index_page
    i_should_see_a_clone_of(course)
  end

  scenario "can delete a course" do
    select_first_course
    select_delete_action
    confirm_action
    i_should_be_back_on_the_index_page
    i_should_not_see(course)
  end

  scenario "can create a new course" do
    select_new_course_action
    i_should_be_on_the_create_a_new_course_page
    #select department.name, from: 'departments-dropdown'
  end
end
