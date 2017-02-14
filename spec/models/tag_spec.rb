require 'rails_helper'

RSpec.describe Tag, type: :model do
  # Using FactoryGirl to build test objects
  let (:career_tag) { build(:career_tag, name: "Software QA Tester") }
  let (:interest_tag) { build(:interest_tag, name: "Finance") }

  context "when describing a career_tag" do
    context "that has a non-blank name" do
      it "is valid" do
        expect(career_tag.valid?).to eq true
      end
    end

    context "that has a blank name" do
      before do
        career_tag.name = ""
      end

      it "is invalid" do
        expect(career_tag.valid?).to eq false
      end
    end
  end

  context "when describing an interest_tag" do
    context "that has a non-blank name" do
      it "is valid" do
        expect(interest_tag.valid?).to eq true
      end
    end

    context "that has a blank name" do
      before do
        interest_tag.name = ""
      end
      it "is invalid" do
        expect(interest_tag.valid?).to eq false
      end
    end
  end

  context "when not describing a career_tag or interest_tag" do
    let (:invalid_tag) { build(:tag, type: "Arbitrary string") }
    it "is invalid" do
      expect(invalid_tag.valid?).to eq false
    end
  end

  describe "#add_module" do

    let (:valid_module) { create(:uni_module) }

    context "when passed a valid module" do
      before do
        career_tag.save
        career_tag.add_module(valid_module)
      end

      it "adds the module to the tag's list of modules" do
        expect(career_tag.uni_modules.include?(valid_module)).to eq true
      end
    end
  end
end
