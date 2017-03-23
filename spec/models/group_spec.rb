require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:group) { create(:group) }

  describe "#valid?" do

    context "when built by FactoryGirl" do
      it "evaluates to true" do
        expect(group.valid?).to eq true
      end
    end

    context "when min is bigger than max" do
      before do
        group.min_credits = 10
        group.max_credits = 5
      end
      it "adds an error to the group" do
        expect(group.valid?).to eq false
      end
    end
    
    context "when name is blank" do
      before do
        group.name = nil
      end
      it "evaluates to false" do
        expect(group.valid?).to eq false
      end
    end

    context "when min_credits is blank" do
      before do
        group.min_credits = nil
      end
      it "evaluates to false" do
        expect(group.valid?).to eq false
      end
    end

    context "when max_credits is blank" do
      before do
        group.max_credits = nil
      end
      it "evaluates to false" do
        expect(group.valid?).to eq false
      end
    end

    context "when it doesn't belong to a YearStructure" do
      before do
        group.year_structure = nil
      end
      it "evaluates to false" do
        expect(group.valid?).to eq false
      end
    end
  end

  describe ".search_by_module" do
    let (:group) { create(:group) }
    let (:uni_module) { create(:uni_module) }

    before do
      group.uni_modules << uni_module
    end

    it "finds the group of the uni_module" do
      expect(Group.search_by_module(uni_module.code)).to include group
    end
  end

  describe "#destroy" do
    it "does not delete the parent year_structure" do
      expect(YearStructure.count).not_to eq 0
      expect{ group.destroy }.not_to change{ YearStructure.count }
    end
  end
end
