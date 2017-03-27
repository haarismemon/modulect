require 'rails_helper'

RSpec.describe SuggestedPathway, type: :model do
  let (:uni_module) { create(:uni_module) }
  let (:course) { create(:course) }
  let (:suggested_pathway) { build(:suggested_pathway, course: course, data: "[[[],[#{uni_module.id}]],[[],[]]]") }

  describe "#valid?" do
    context "when created by FactoryGirl" do
      it "evaluates to true" do
        expect(suggested_pathway.valid?).to eq true
      end
    end
  end

  describe "#get_module_list" do
    it "gets the modules" do
      expect(suggested_pathway.get_module_list).to include uni_module
    end
  end
end
