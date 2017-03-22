module PathwaySearchSteps

  def fill_in_begin_form
    select nms.to_s.titleize, from: 'faculties_select'
    wait_for_ajax
    select informatics.to_s.titleize, from: 'departments_select'
    wait_for_ajax
    select "BSc Computer Science (started 2015)", from: 'courses_select'
    select "1", from: 'year_of_study_select'
  end

  def select_first_three_tags
    find("#modulect-tag-0").click
    find("#modulect-tag-1").click
    find("#modulect-tag-2").click
  end

  def i_should_see_all_compulsory_modules_for_my_year
    cs_year_1.groups.each do |group|
      if group.compulsory?
        group.uni_modules.each do |uni_module|
          expect(page).to have_content uni_module.name
        end
      end
    end
  end
end
