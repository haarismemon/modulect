require 'rails_helper'
require 'support/career_search_steps'

feature "Student searching for a career", :js => true do
  include CareerSearchSteps
  
  fixtures :departments
  fixtures :faculties
  fixtures :courses
  fixtures :interest_tags
  fixtures :career_tags
  fixtures :uni_modules
  fixtures :groups
  fixtures :users

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

  given (:james) { users(:james) }

  before do
    setup_seed_associations
    page.set_rack_session(user_id: james.id)
  end

  scenario "can perform a career search" do
    visit root_path
    click_on "Start"
    fill_in_begin_form
    click_on "Next"
    find("label[for='4CCS1IAI']")
    find("label[for='4CCS1IAI']").click
    find("label[for='4CCS1DST']").click
    find("label[for='4CCS1DBS']").click
    find("label[for='4CCS1PRA']").click
    click_on "View careers"

    expect(page).to have_content "Database Engineer"
    expect(page).to have_content "Front-end Developer"
    expect(page).to have_content "Hardware Engineer"
    expect(page).to have_content "Logic Engineer"
    expect(page).to have_content "Network Engineer"
    expect(page).to have_content "Software Engineer"
  end
end
