require 'rails_helper'

RSpec.describe CareerSearchHelper, type: :helper do
  fixtures :uni_modules
  fixtures :interest_tags
  fixtures :career_tags

  let (:prp) { uni_modules(:prp) }
  let (:pra) { uni_modules(:pra) }

  let (:modules) { [prp, pra] }

  describe "#get_carrer_tags_from_modules" do

    it "gets the career tags from the given modules" do
      returned_tags = helper.get_career_tags_from_modules(modules)
      expect(returned_tags).not_to be_blank
      modules.each do |uni_module|
        uni_module.career_tags.each do |career_tag|
          expect(returned_tags).to include career_tag
        end
      end
    end
  end

  describe "#get_module_which_contains_tag" do
    let (:tag) { career_tags(:software_engineer) }

    it "gets the modules that contain the specified tag" do
      returned_modules = helper.get_module_which_contains_tag(tag, modules)
      expect(returned_modules).not_to be_blank
      expect(returned_modules).to eq modules
    end
  end
end
