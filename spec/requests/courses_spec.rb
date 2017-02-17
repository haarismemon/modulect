require 'rails_helper'

RSpec.describe "Courses", type: :model do
  let(:course) { build(:course) }

  describe "#valid?" do

    context "when name is present and unique, and year is present" do
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

    context "when name is already taken" do
      before do
        create(:course, name: course.name)
      end
      it "does have a name" do
        expect(course.name).not_to be_blank
      end
      it "evaluates to false" do
        expect(course.valid?).to eq false
      end
    end

    context "when year is blank" do
      before do
        course.year = nil
      end

      it "evaluates to false" do
        expect(course.valid?).to eq false
      end
    end
  end
end
