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
  given (:existing_comment) { comments(:comment)}

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
    find("#helpful-btn-#{existing_comment.id}").click
    find("#report-btn-#{existing_comment.id}").click
    find("#edit-btn-#{Comment.last.id}").click
    fill_in "edit-text-area", with: "A very, very good module!"
    find("#submit-btn").click
    expect(page).to have_content "A very, very good module!"
    expect(page).to have_current_path(uni_module_path(prp))
    find("#delete-btn-#{Comment.last.id}").click
    expect(page).to have_current_path(uni_module_path(prp))
  end
end
