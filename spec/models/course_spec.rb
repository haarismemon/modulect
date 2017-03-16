require 'rails_helper'

RSpec.describe Course, type: :model do

  let(:course) { build(:course) }

  describe "#valid?" do

    context "when built by FactoryGirl" do
      it "evaluates to true" do
        expect(course.valid?).to eq true
      end
    end

    context "when name is present" do
      it "evaluates to true" do
        expect(course.valid?).to eq true
      end
    end

    context "when name is blank" do
      before do
        course.name = nil
      end
      it "evaluates to false" do
        expect(course.valid?).to eq false
      end
    end

    context "when there is another course with same name and year" do
      before do
        create(:course, name: course.name, year: course.year)
      end
      it "evaluates to false" do
        expect(course.valid?).to eq false
      end
    end
  end

  describe "#create_year_structures" do
    before do
      course.save
    end

    context "as a course created by FactoryGirl" do
      before do
        course.create_year_structures
      end

      it "has 3 year structures" do
        expect(course.year_structures.count).to eq 3
      end
    end

    context "when created with an arbitrary 'duration_in_years' field " do
      before do
        course.duration_in_years = 4
        course.create_year_structures
      end
      it "has a year structure for each year" do
        expect(course.year_structures.count).to eq course.duration_in_years
      end
    end
  end

  describe "#update_year_structures" do
    before do
      course.save
      course.create_year_structures
    end

    context "when the pre and post update year durations are the same" do
      before do
        course.duration_in_years = 3
        course.update_year_structures(3)
      end
      it "doesn't change the year_structures count" do
        expect(course.year_structures.count). to eq 3
      end
    end

    context "when the year duration is increased by 1" do
      before do
        course.duration_in_years = 4
        course.update_year_structures(3)
      end
      it "adds an extra YearStructure" do
        expect(course.year_structures.count).to eq 4
        expect(course.year_structures.last.year_of_study).to eq "fourth_year"
      end
    end

    context "when the year duration is increased by 3" do
      before do
        course.duration_in_years = 6
        course.update_year_structures(3)
      end

      it "adds 3 extra YearStructures" do
        expect(course.year_structures.count).to eq 6
      end
    end
  end

  describe "#add_department" do
    let(:valid_department) { create(:department) }

    context "when adding a valid department" do
      before do
        course.save
        course.add_department(valid_department)
      end

      it "adds the department to the course's list of departments" do
        expect(course.departments.include?(valid_department)).to eq true
      end
    end
  end

  describe "cascading delete" do
   
    before do
      course.save
      create(:year_structure, course: course)
    end

    it "deletes the year_structure as well" do
      expect(YearStructure.count).not_to eq 0
      course.destroy
      expect(YearStructure.count).to eq 0
    end
  end
end
