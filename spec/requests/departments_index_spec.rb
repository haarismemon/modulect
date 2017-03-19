require 'rails_helper'
require 'support/login_helper'
require 'support/departments_index_steps'

feature "System Admin visiting index page of departments", :js => true do
  include LoginHelper
  include DepartmentsIndexSteps

  given! (:department) { create(:department) }
  given! (:admin) { create(:user, first_name: "Vlad", last_name: "Nedelescu",
                           email: "vlad.nedelescu@kcl.ac.uk", user_level: "super_admin_access") }
  given! (:course) { create(:course) }

  before do
    visit admin_departments_path
    login_user(admin, "password")
  end

  scenario "can clone a department" do
    select_first_checkbox
    select_clone_action
    confirm_action
    i_should_be_on_the_departments_index_page
    i_should_see_a_clone_of(department)
  end

  scenario "can delete a course" do
    select_first_checkbox
    select_delete_action
    confirm_action
    i_should_be_on_the_departments_index_page
    i_should_not_see(department)
  end

  scenario "can edit a department" do
    select_edit_action
    fill_in_department_form
    click_button "Update"
    i_should_see_an_update_success_flash
    i_should_see_the_name_of_the_new_department
    i_should_be_on_the_departments_index_page
  end
end
