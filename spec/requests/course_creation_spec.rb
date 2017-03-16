require 'rails_helper'
require 'support/login_helper'
require 'support/course_creation_steps'
require 'support/wait_for_ajax'

feature "Creating a new course", :js => true do
  include LoginHelper
  include CourseCreationSteps
  include WaitForAjax

  given! (:admin) { create(:user, first_name: "Omar", last_name: "Rahman",
                           email: "omar.rahman@kcl.ac.uk", user_level: "super_admin_access") }
  given! (:course) { create(:course) }
  given! (:department) { create(:department) }
  given! (:uni_module) { create(:uni_module) }

  before do
    visit admin_courses_path
    login_user(admin, "password")
  end

  scenario "allows a module group to be defined for First Year" do
    select_new_course_action
    i_should_be_on_the_create_a_new_course_page
    fill_in_course_form(department)
    click_button "Create"
    find("#modify-1").click
    i_should_be_on_the_edit_page_of_the_new_course
    find('.add_fields').click
    wait_for_ajax
    fill_in_new_group_form
    click_button "Update"
    i_should_be_on_the_edit_page_of_the_new_course
  end
end
