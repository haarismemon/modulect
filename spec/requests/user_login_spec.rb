require 'rails_helper'
require 'support/login_helper'

feature "Logging in" do
  include LoginHelper

  given! (:user) { create(:user) }

  scenario "as an activated user" do
    visit login_path
    login_user(user, "password")
    expect(page).to have_current_path(root_path)
  end

  scenario "as a user that has not been activated" do
    visit login_path
    user.update_columns(activated: false, activated_at: nil)
    login_user(user, "password")
    expect(page).to have_current_path(root_path)
  end

  scenario "without entering anything" do
    visit login_path
    within("#login-area") do
      click_button "Log in"
    end
    expect(page).to have_current_path(login_path)
  end
end
