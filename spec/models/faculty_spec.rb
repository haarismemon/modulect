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

  describe ".to_csv" do
    let! (:department) { create(:department, faculty: faculty) }
    let (:csv_content) { Faculty.to_csv }
    let (:csv_header) { "name,departments\n" }

    before do
      faculty.save
      faculty.departments << department
    end

    it "outputs all saved courses" do
      expect(csv_content).to include csv_header
      test_csv_attributes_for_all_faculties
    end

    context "when a faculty doesn't have any departments" do
      before do
        department.destroy
      end

      it "doesn't crash" do
        expect(csv_content).to include csv_header
        test_csv_attributes_for_all_faculties
      end
    end
  end

  private
  def test_csv_attributes_for_all_faculties
    faculties = Faculty.all
    csv_content.slice! csv_header
    i = 0
    CSV.parse(csv_content) do |line|
      line = line.join(",")
      faculty = faculties[i]
      expect(line).to include faculty.to_s
      faculty.departments.each do |department|
        expect(line).to include department.to_s
      end
      i += 1
    end
  end

end
