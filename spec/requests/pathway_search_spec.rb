require 'rails_helper'
#require 'support/login_helper'
require 'support/wait_for_ajax'
require 'support/pathway_search_steps'

feature "Student searching for module pathway", :js => true do
  #include LoginHelper
  include WaitForAjax
  include PathwaySearchSteps
  
  fixtures :users
  fixtures :courses
  fixtures :departments
  fixtures :faculties
  fixtures :interest_tags
  fixtures :career_tags
  fixtures :uni_modules
  fixtures :year_structures
  fixtures :groups

  given(:user) { users(:sophie) }

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

    # Tag association
    prp.tags << programming
    pra.tags << programming
    fc1.tags << maths
    fc2.tags << maths
    iai.tags << robotics
    dst.tags << algorithms
    fc2.tags << algorithms
    iai.tags << artificial_intelligence
    prp.tags << software_engineer
    pra.tags << software_engineer
    ins.tags << network_engineer
    ela.tags << logic_engineer
    dbs.tags << database_engineer
    cs1.tags << hardware_engineer
    pra.tags << front_end_developer

    nms.departments << informatics

    computer_science_15.year_structures << cs_year_1
    computer_science_15.year_structures << cs_year_2

    # Group-Modules association
    cs1_semester_1.uni_modules << prp
    cs1_semester_1.uni_modules << ela
    cs1_semester_1.uni_modules << fc1
    cs1_semester_1.uni_modules << cs1
    cs1_semester_2.uni_modules << pra
    cs1_semester_2.uni_modules << dst
    cs1_semester_2.uni_modules << dbs
    cs1_semester_2.uni_modules << iai
    cs2_semester_1.uni_modules << ins
    cs2_semester_2.uni_modules << fc2

    # Group-YearStructure association
    cs_year_1.groups << cs1_semester_1
    cs_year_1.groups << cs1_semester_2
    cs_year_2.groups << cs2_semester_1
    cs_year_2.groups << cs2_semester_2

    informatics.courses << computer_science_15
  end


  scenario "can select and save their modules" do
    visit root_path
    click_on "Begin Search"
    fill_in_begin_form
    click_on "Next"
    select_first_three_tags
    click_on "View results"
    binding.pry
    i_should_see_all_compulsory_modules_for_my_year
  end
end
