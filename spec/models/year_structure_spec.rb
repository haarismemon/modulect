require 'rails_helper'

RSpec.describe YearStructure, type: :model do
  let (:year_structure) { build(:year_structure) }

  describe "#valid?" do

    context "when created by FactoryGirl" do
      it "evaluates to true" do
        expect(year_structure.valid?).to eq true
      end
    end

    context "when year of study is blank" do
      before do
        year_structure.year_of_study = nil
      end
      it "evaluates to false" do
        expect(year_structure.valid?).to eq false
      end
    end

    context "when not belonging to a course" do
      before do
        year_structure.course = nil
      end
      it "evaluates to false" do
        expect(year_structure.valid?).to eq false
      end
    end
  end
end
