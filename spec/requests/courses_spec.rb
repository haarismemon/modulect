require 'rails_helper'

RSpec.describe "Courses", type: :request do
  let(:course) { build(:course) }

  describe "#valid?" do

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
  end
end
