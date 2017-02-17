require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { build(:group) }
  
  describe "#valid?" do

    context "when built by FactoryGirl" do
      it "evaluates to true" do
        expect(group.valid?).to eq true
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

    context "when total_credits is blank" do
      before do
        group.total_credits = nil
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
end
