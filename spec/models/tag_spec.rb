require 'rails_helper'

RSpec.describe Tag, type: :model do
  # Using FactoryGirl to build a test object
  let (:career) { build(:career, name: "Software QA Tester") }
  let (:interest) { build(:interest, name: "Finance") }

  context "when describing a career" do
    context "that has a non-blank name" do
      it "is valid" do
        expect(career.valid?).to eq true
      end
    end

    context "that has a blank name" do
      before do
        career.name = ""
      end

      it "is invalid" do
        expect(career.valid?).to eq false
      end
    end
  end

  context "when describing an interest" do
    context "that has a non-blank name" do
      it "is valid" do
        expect(interest.valid?).to eq true
      end
    end

    context "that has a blank name" do
      before do
        interest.name = ""
      end
      it "is invalid" do
        expect(interest.valid?).to eq false
      end
    end
  end

  context "when not describing a career or interest" do
    let (:invalid_tag) { build(:tag, type: "Arbitrary string") }
    it "is invalid" do
      expect(invalid_tag.valid?).to eq false
    end
  end
end
