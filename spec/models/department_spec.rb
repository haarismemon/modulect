require 'rails_helper'

RSpec.describe Department, type: :model do

  let(:department) { build(:department) }

  describe "#valid?" do

    context "when name is present" do
      context "and unique" do
        it "evaluates to true" do
          expect(department.valid?).to eq true
        end
      end

      context "but already taken" do
        before do
          create(:department, name: department.name)
        end
        it "evaluates to false" do
          expect(department.valid?).to eq false
        end
      end
    end

    context "when name is blank" do
      before do
        department.name = nil
      end
      it "evaluates to false" do
        expect(department.valid?).to eq false
      end
    end
  end

  describe "#add_course" do

    let(:valid_course) { create(:course) }

    context "when adding a valid course" do
      before do
        department.save
        department.add_course(valid_course)
      end

      it "adds the course to the department's list of courses" do
        expect(department.courses.include?(valid_course)).to eq true
      end
    end
  end
end
