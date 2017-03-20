require 'rails_helper'

RSpec.describe Faculty, type: :model do

  let(:faculty) { build(:faculty) }

  describe "#valid?" do

    context "when name is present" do
      context "and unique" do
        it "evaluates to true" do
          expect(faculty.valid?).to eq true
        end
      end

      context "but already taken" do
        before do
          create(:faculty, name: faculty.name)
        end
        it "evaluates to false" do
          expect(faculty.valid?).to eq false
        end
      end
    end

    context "when name is blank" do
      before do
        faculty.name = nil
      end
      it "evaluates to false" do
        expect(faculty.valid?).to eq false
      end
    end
  end

  describe "#to_s" do
    it "returns the name" do
      expect(faculty.to_s).to eq faculty.name
    end
  end
end
