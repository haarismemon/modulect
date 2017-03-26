module LoginHelper
  # Must be called after visiting a login page.
  def login_user(user, password)
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: password
      click_button "Log in"
    end
  end

  def log_out
    find("#user-actions").click
    find("#logout-user").click
    page.set_rack_session(user_id: nil)
  end
end
