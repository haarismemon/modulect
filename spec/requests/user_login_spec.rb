require 'rails_helper'

feature "Logging in" do

  given(:user) { create(:user) }

  scenario "as an activated user" do
    visit login_path
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: "password"
    end
    click_button "Log in"
    expect(page).to have_content "Logged in"
  end

  scenario "as a user that has not been activated" do
    user.update_columns(activated: false, activated_at: nil)
    visit login_path
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: "password"
    end
    click_button "Log in"
    expect(page).not_to have_content "Logged in"
  end

  scenario "with invalid credentials" do
      visit login_path
      click_button "Log in"
      expect(page).not_to have_content 'Logged in'
  end
end
