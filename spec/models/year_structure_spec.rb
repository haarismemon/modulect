require 'rails_helper'

RSpec.describe YearStructure, type: :model do
  let!(:year_structure) { build(:year_structure) }

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
      it "evaluates to false, as a year_structure must belong to a course" do
        expect(year_structure.valid?).to eq false
      end
    end
  end

  describe "#to_s" do
    it "stringifies the object as 'course.year' + 'year_of_study.titleize'" do
      expect(year_structure.to_s).to eq "#{year_structure.year_of_study.titleize}"
    end
  end

  describe "#max_year_of_study" do
    it "should return 7" do
      expect(YearStructure.max_year_of_study).to eq 7
    end
  end

  describe "#groups_existent?" do

    context "when no groups belong to this year_structure" do
      it "evaluates to false" do
        expect(year_structure.groups_existent?).to eq false
      end
    end

    context "when it has at least one group" do
      before do
        year_structure.save
        group = create(:group, name: "My Module Group", year_structure: year_structure)
      end

      it "evaluates to true" do
        expect(year_structure.groups_existent?).to eq true
      end
    end
  end
end
