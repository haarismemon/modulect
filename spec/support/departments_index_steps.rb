require 'support/bulk_actions_steps'
require 'support/selectize_select'

module DepartmentsIndexSteps
  include BulkActionsSteps
  include SelectizeSelect

  def fill_in_department_form
    fill_in "Name", with: "New Department"
  end

  def select_edit_action
    find(".action-edit").click
  end

  def click_delete_link
    click_on "Delete"
  end

  def confirm_delete
    click_on "Proceed"
  end
  
  def i_should_be_on_the_departments_index_page
    expect(page).to have_current_path admin_departments_path
  end

  def i_should_see_an_update_success_flash
    assert_text "updated"
  end

  def i_should_see_the_name_of_the_new_department
    expect(page).to have_content Department.last.to_s
  end

  def i_should_see_a_clone_of(department)
    expect(page).to have_content(department.to_s)
    expect(page).to have_content("#{department.to_s}-CLONE")
  end

  def i_should_not_see(department)
    expect(page).not_to have_content(department.to_s)
  end
end
