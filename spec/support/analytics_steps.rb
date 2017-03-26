module AnalyticsSteps
  def setup_sophies_details

  end
  def review_a_module
    visit uni_module_path(prp)
    click_button "Save"
    find('#comment-creation-link').click
    fill_in "comment_body", with: "An incredible module"
    stars = page.all("ul.star-rating li")
    stars[1].click
    click_on 'Add Review'
  end

  def visit_some_modules
    visit uni_module_path(prp)
    visit uni_module_path(pra)
    visit uni_module_path(prp) 
  end

  def login_and_visit_analytics_page
    visit admin_analytics_path
    login_user(admin, 'password')
    page.set_rack_session(user_id: admin.id)
    visit admin_analytics_path
  end
end
