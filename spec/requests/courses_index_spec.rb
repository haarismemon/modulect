require 'timeout'
require 'rails_helper'
require 'support/login_helper'
require 'support/courses_index_steps'
require 'pry'

feature "Index page of courses: admin", :js => true do
  include LoginHelper
  include CoursesIndexSteps

  given! (:admin) { create(:user, first_name: "Vlad", last_name: "Nedelescu",
                           email: "vlad.nedelescu@kcl.ac.uk", user_level: "super_admin_access") }
  given! (:course) { create(:course) }
  given! (:department) { create(:department) }
  given! (:uni_module) { create(:uni_module) }

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

  scenario "can edit a course" do
    select_edit_action
    fill_in_course_form(department)
    click_update_button
    i_should_see_the_name_of_the_new_course
    i_should_be_on_the_edit_page_of_the_new_course
  end
end
