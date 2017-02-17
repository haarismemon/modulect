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
end
