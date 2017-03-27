require 'support/review_module'

module AnalyticsSteps
  include ReviewModule

  def review_a_module(uni_module)
    review_module(uni_module)
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
