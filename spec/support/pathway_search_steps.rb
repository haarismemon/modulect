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

  def select_first_optional_module
    find("#module-cell-7").find("button").click
    find("#btn_opt_year_0_group_1").click
    first_optional_module = cs1_semester_2.uni_modules.first
    find("#btn_opt_select_" + first_optional_module.id.to_s).click
  end

  def select_second_optional_module
    find("#module-cell-7").find("button").click
    find("#btn_opt_year_0_group_1").click
    second_optional_module = cs1_semester_2.uni_modules.second
    find("#btn_opt_select_" + second_optional_module.id.to_s).click
  end

  def select_third_optional_module
    find("#module-cell-7").find("button").click
    find("#btn_opt_year_0_group_1").click
    third_optional_module = cs1_semester_2.uni_modules.third
    find("#btn_opt_select_" + third_optional_module.id.to_s).click
  end

  def select_fourth_optional_module
    find("#module-cell-7").find("button").click
    find("#btn_opt_year_0_group_1").click
    fourth_optional_module = cs1_semester_2.uni_modules.fourth
    find("#btn_opt_select_" + fourth_optional_module.id.to_s).click
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

  def i_should_see_my_selected_optional_modules_for_first_year
    cs1_semester_2.uni_modules.each do |uni_module|
      expect(page).to have_content(uni_module.name)
    end
  end
end
