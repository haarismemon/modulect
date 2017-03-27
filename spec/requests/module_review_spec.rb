require 'rails_helper'
require 'support/login_helper'
require 'support/module_review_steps'

feature 'Reviewing a module', :js => true do
  include LoginHelper
  include ModuleReviewSteps

  fixtures :uni_modules
  fixtures :users
  fixtures :courses
  fixtures :departments
  fixtures :comments

  given(:prp) { uni_modules(:prp) }

  given! (:sophie) { users(:sophie) }

  before do
    visit login_path
    login_user(sophie, 'password')
    page.set_rack_session(user_id: sophie.id)
    page.set_rack_session(last_login_time: sophie.last_login_time)
  end
  
  scenario "can review a module" do
    review_module(prp)
    find("#sort-comments-by").click
    find("option[value='rating']").click
    find(".helpful-btn").click
  end
end
