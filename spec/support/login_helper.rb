module LoginHelper
  def login_user(user, password)
    within("#login-area") do
      fill_in "session_email",    with: user.email
      fill_in "session_password", with: password
      click_button "Log in"
    end
  end
end
