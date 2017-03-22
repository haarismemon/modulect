require 'support/wait_for_ajax'

module BulkActionsSteps
  include WaitForAjax

  def select_first_checkbox
    find("#check_individual[value='1']").set(true)
  end

  def select_bulk_clone
    find("#bulk-actions").click
    find("#clone-all").click
  end

  def select_bulk_delete
    find("#bulk-actions").click
    find("#delete-all").click
  end

  def confirm_bulk_action
    wait_for_ajax
    click_button("Proceed")
    click_button("OK")
  end
end
