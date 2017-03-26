require 'rails_helper'
require 'support/login_helper'
require 'support/analytics_steps'

feature 'Analytics', :js => true do
  include LoginHelper
  include AnalyticsSteps

  fixtures :uni_modules
  fixtures :users
  fixtures :courses
  fixtures :departments

  # Modules
  given(:prp) { uni_modules(:prp) }
  given(:pra) { uni_modules(:pra) }

  given! (:admin) { users(:super_admin) }
  given! (:sophie) { users(:sophie) }

  before do
    visit login_path
    login_user(sophie, 'password')
    page.set_rack_session(user_id: sophie.id)
    page.set_rack_session(last_login_time: sophie.last_login_time)
  end

  context "statistics" do
    it "displays all statistics" do 
      review_a_module
      visit_some_modules
      log_out
      login_and_visit_analytics_page

      expect(page).to have_current_path(admin_analytics_path)
      expect(find("#number-of-visitors").text).not_to eq "0"
      expect(page).to have_css('#most-active-students-card', text: sophie.first_name)
      expect(page).to have_css('#trending-modules-card', text: prp.name)
      expect(page).to have_css('#trending-modules-card', text: pra.name)
      expect(page).to have_css("#top-reviewed-modules-card", text: prp.name)
      expect(page).to have_css("#most-saved-modules-card")
      expect(page).to have_css("#device-usage-card")
      expect(page).to have_css("#users-logged-in-card")
      expect(page).to have_css("#most-active-departments-card", text: sophie.department.to_s)
    end
  end
end
