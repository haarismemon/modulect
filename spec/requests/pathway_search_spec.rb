require 'rails_helper'
require 'support/login_helper'
require 'support/wait_for_ajax'
require 'support/pathway_search_steps'
require 'timeout'

feature "Student searching for module pathway", :js => true do
  include LoginHelper
  include WaitForAjax
  include PathwaySearchSteps
  
  fixtures :users
  fixtures :courses
  fixtures :departments
  fixtures :faculties
  fixtures :interest_tags
  fixtures :career_tags
  fixtures :uni_modules
  fixtures :groups

  given(:sophie) { users(:sophie) }

  given(:computer_science_15) { courses(:computer_science_15) }
  given(:informatics) { departments(:informatics) }
  given(:nms) { faculties(:nms) }

  # Modules
  given(:prp) { uni_modules(:prp) }
  given(:pra) { uni_modules(:pra) }
  given(:fc1) { uni_modules(:fc1) }
  given(:fc2) { uni_modules(:fc2) }
  given(:iai) { uni_modules(:iai) }
  given(:dst) { uni_modules(:dst) }
  given(:dbs) { uni_modules(:dbs) }
  given(:ela) { uni_modules(:ela) }
  given(:ins) { uni_modules(:ins) }
  given(:cs1) { uni_modules(:cs1) }

  # Year Structures
  given(:cs_year_1) { computer_science_15.year_structures.build(year_of_study: 1) }
  given(:cs_year_2) { computer_science_15.year_structures.build(year_of_study: 2) }

  # Groups
  given(:cs1_semester_1) { groups(:cs1_semester_1) }
  given(:cs1_semester_2) { groups(:cs1_semester_2) }
  given(:cs2_semester_1) { groups(:cs2_semester_1) }
  given(:cs2_semester_2) { groups(:cs2_semester_2) }

  # Tags
  given(:programming) { interest_tags(:programming) }
  given(:maths) { interest_tags(:maths) }
  given(:robotics) { interest_tags(:robotics) }
  given(:algorithms) { interest_tags(:algorithms) }
  given(:artificial_intelligence) { interest_tags(:artificial_intelligence) }
  given(:software_engineer) { career_tags(:software_engineer) }
  given(:network_engineer) { career_tags(:network_engineer) }
  given(:logic_engineer) { career_tags(:logic_engineer) }
  given(:database_engineer) { career_tags(:database_engineer) }
  given(:front_end_developer) { career_tags(:front_end_developer) }
  given(:hardware_engineer) { career_tags(:hardware_engineer) }

  before do
    setup_database_associations
  end

  scenario "can select and save their modules" do
    visit login_path
    login_user(sophie, 'password')
    visit root_path
    click_on "Begin Search"
    fill_in_begin_form
    click_on "Next"
    select_first_three_tags
    click_on "View results"
    i_should_see_all_compulsory_modules_for_my_year

    select_first_optional_module
    sleep(1)

    select_second_optional_module
    sleep(1)

    select_third_optional_module
    sleep(1)

    select_fourth_optional_module

    i_should_see_my_selected_optional_modules_for_first_year
  end
end
