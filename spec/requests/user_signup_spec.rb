require 'rails_helper'

feature "Signing up" do

  scenario "with valid credentials" do
    visit signup_path
    within("#login-area") do
      fill_in "user_first_name",            with: "Vlad"
      fill_in "user_last_name",             with: "Nedelescu"
      fill_in "user_email",                 with: "user@kcl.ac.uk"
      fill_in "user_password",              with: "password"
      fill_in "user_password_confirmation", with: "password"
    end
    click_button "Sign up"
    expect(page).to have_content 'check your email to activate your account'
  end

  scenario "Signing up with invalid credentials" do
      visit signup_path
      click_button "Sign up"
      expect(page).to have_content 'Sign up'
  end
end
