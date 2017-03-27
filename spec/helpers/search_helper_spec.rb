require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SearchHelper. For example:
#
# describe SearchHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SearchHelper, type: :helper do
  let (:course) { create(:course) }
  let (:uni_module_1) { create(:uni_module) }
  let (:uni_module_2) { create(:uni_module, name: "Whatever", code: "4CSV1PRP", semester: "2", credits: 15) }
  let (:career_tag) { create(:career_tag) }
  let (:year_structure) { create(:year_structure, course: course) }
  let (:group) { create(:group, year_structure: year_structure) }

  describe "#every_tag_for_course" do
    before do
      uni_module_1.tags << career_tag
      uni_module_2.tags << career_tag

      group.uni_modules << uni_module_1
      group.uni_modules << uni_module_2

      year_structure.groups << group
    end

    context "when the course contains modules that have tags" do
      it "returns [tag.name, module.name, module.code] for each module" do

        result = helper.every_tag_for_course(course).join(",")

        expect(result).to include career_tag.name
        expect(result).to include uni_module_1.name
        expect(result).to include uni_module_1.code

        expect(result).to include uni_module_2.name
        expect(result).to include uni_module_2.code
      end
    end
  end

  describe "#get_course_of_user" do
    let (:user) { create(:user) }

    it "returns the  }urse of the user" do
      expect(helper.get_course_of_user(user)).to eq user.course
    end
  end

  describe "#modules_in_course" do
    let (:course) { create(:course) }
    let (:uni_module_1) { create(:uni_module) }
    let (:uni_module_2) { create(:uni_module, name: "Whatever", code: "4CSV1PRP", semester: "2", credits: 15) }
    let (:year_structure) { create(:year_structure, course: course) }
    let (:group) { create(:group, year_structure: year_structure) }

    before do
      group.uni_modules << uni_module_1
      group.uni_modules << uni_module_2

      year_structure.groups << group
    end

    it "returns all the ids of the modules in the course" do
      result = helper.modules_in_course(course).join(",")

      expect(result).to include uni_module_1.id.to_s
      expect(result).to include uni_module_2.id.to_s
    end
  end
end
