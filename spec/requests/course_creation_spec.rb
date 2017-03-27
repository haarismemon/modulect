require 'rails_helper'
require 'support/login_helper'
require 'support/course_creation_steps'
require 'support/wait_for_ajax'
require 'support/bulk_actions_steps'

feature "Creating a new course", :js => true do
  include LoginHelper
  include CourseCreationSteps
  include WaitForAjax
  include BulkActionsSteps

  given! (:admin) { create(:user, first_name: "Omar", last_name: "Rahman",
                           email: "omar.rahman@kcl.ac.uk", user_level: "super_admin_access") }
  given! (:department) { create(:department) }
  given! (:prp) { create(:uni_module, name: "Programming Practice", code: "4CCS1PRP") }
  given! (:pra) { create(:uni_module, name: "Programming Applications", code: "4CCS1PRA") }

  before do
    visit admin_courses_path
    login_user(admin, "password")
  end

  scenario "allows a module group to be defined for each year, and can deep clone the course" do
    create_new_course_belonging_to(department)
    assert_text "Edit"
    define_a_module_group_for_each_year_structure([prp, pra])
    clone_first_course_on_index_page
  end
end
