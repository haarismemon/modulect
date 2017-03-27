require 'support/setup_seed_associations'
require 'support/wait_for_ajax'

module CareerSearchSteps
  include SetupSeedAssociations
  include WaitForAjax

  def fill_in_begin_form
    select nms.to_s.titleize, from: 'faculties_select'
    wait_for_ajax
    select informatics.to_s.titleize, from: 'departments_select'
    wait_for_ajax
    select "BSc Computer Science (started 2015)", from: 'courses_select'
    select "1", from: 'user_year_of_study'
  end
end
