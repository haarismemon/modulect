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
          department.dup.save
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

  describe "#to_s" do
    it "returns the name" do
      expect(department.to_s).to eq department.name
    end
  end

  describe ".to_csv" do
    let (:csv_content) { Department.to_csv }
    let (:csv_header) { "Name,Faculty\n" }

    before do
      department.save
    end

    it "outputs all saved departments" do
      expect(csv_content).to include csv_header
      test_csv_attributes_for_all_departments
    end
  end

  private
  def test_csv_attributes_for_all_departments
    departments = Department.all
    csv_content.slice!(csv_header)
    i = 0
    CSV.parse(csv_content).each do |line|
      expect(line).to include departments[i].name
      expect(line).to include departments[i].faculty.to_s
      i += 1
    end
  end
end
