require 'rails_helper'
require 'support/login_helper'
require 'support/courses_index_steps'

feature "Admin visiting index page of courses", :js => true do
  include LoginHelper
  include CoursesIndexSteps

  given! (:admin) { create(:user, first_name: "Vlad", last_name: "Nedelescu",
                           email: "vlad.nedelescu@kcl.ac.uk", user_level: "super_admin_access") }
  given! (:course) { create(:course) }
  given! (:department) { create(:department) }

  before do
    visit admin_courses_path
    login_user(admin, "password")
    i_should_be_on_the_courses_index_page
  end

  scenario "can clone a course" do
    select_first_checkbox
    select_bulk_clone
    confirm_action
    i_should_be_on_the_courses_index_page
    i_should_see_a_clone_of(course)
  end

  context "can delete a course" do
    scenario "by 'Delete' link press" do
      click_delete_link
      wait_for_ajax
      confirm_bulk_delete
      i_should_be_on_the_courses_index_page
      i_should_not_see(course)
    end

    scenario "by bulk delete" do
      select_first_checkbox
      select_bulk_delete
      wait_for_ajax
      confirm_bulk_delete
      i_should_be_on_the_courses_index_page
      i_should_not_see(course)
    end
  end

  scenario "can edit a course" do
    select_edit_action
    fill_in_course_form(department)
    click_update_button
    i_should_see_an_update_success_flash
    i_should_see_the_name_of_the_new_course
    i_should_be_on_the_edit_page_of_the_new_course
  end
end
