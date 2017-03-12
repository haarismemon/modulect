require 'rails_helper'
require 'support/login_helper'
require 'support/wait_for_ajax'

feature "Cloning a course", :js => true do
  include LoginHelper

  given (:admin) { create(:user, user_level: "super_admin_access") }
  given! (:course) { create(:course) }

  scenario "works" do
    login_user(admin, "password")
    visit admin_courses_path
    find("#check_individual[value='1']").set(true)
    find("#bulk-actions").click
    find("#clone-all").click
    wait_for_ajax
    click_button("Proceed")
    expect(page).to have_content("#{course.name}-CLONE")
  end
end
