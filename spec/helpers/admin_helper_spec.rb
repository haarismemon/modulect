require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the AdminHelper. For example:
#
# describe AdminHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AdminHelper, type: :helper do
  fixtures :uni_modules
  fixtures :career_tags

  describe "has_linked_tags" do
    context "when passed a module with tags" do
      let (:uni_module) { uni_modules(:pra) }
      it "evaluates to true" do
        expect(helper.has_linked_tags(uni_module)).to eq true
      end
    end
    context "when passed a module without tags" do
      let (:uni_module) { uni_modules(:ins) }
      it "evaluates to false" do
        expect(helper.has_linked_tags(uni_module)).to eq false
      end
    end
  end

  describe "possible_uni_modules_for_new_group" do
    fixtures :users
    fixtures :departments

    context "when called by a super admin" do
      let (:admin) { users(:super_admin) }
      it "returns all uni_modules" do
        expect(helper.possible_uni_modules_for_new_group(admin)).to eq UniModule.all
      end
    end

    context "when called by a department admin" do
      let (:department_admin) { users(:department_admin) }
      it "returns only the admin's department uni_modules" do
        expect(helper.possible_uni_modules_for_new_group(department_admin)).to eq department_admin.department.uni_modules
      end
    end
  end

  describe "#get_num_depts_for_faculty" do
    fixtures :faculties
    let (:faculty) { faculties(:nms) }

    it "returns the departments count of that faculty" do
      expect(helper.get_num_depts_for_faculty(faculty)).to eq faculty.departments.count
    end
  end

  describe "#get_num_departments_for_course" do
    fixtures :departments
    fixtures :courses
    let (:course) { courses(:computer_science_15) }

    it "returns the departments count in pluralized form for that faculty" do
      result = helper.get_num_departments_for_course(course)
      count = course.departments.count
      expect(result).to eq "#{count} #{'Department'.pluralize(count)}"
    end
  end
end
