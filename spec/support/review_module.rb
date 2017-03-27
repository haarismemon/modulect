module ReviewModule
  def review_module(uni_module)
    visit uni_module_path(uni_module)
    click_button "Save"
    find('#comment-creation-link').click
    fill_in "comment_body", with: "An incredible module"
    stars = page.all("ul.star-rating li")
    stars[1].click
    click_on 'Add Review'
  end
end
