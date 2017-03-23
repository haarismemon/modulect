require 'rails_helper'

RSpec.describe Course, type: :model do

  let (:course) { build(:course) }

  describe "#valid?" do

    context "when built by FactoryGirl" do
      it "evaluates to true" do
        expect(course.valid?).to eq true
      end
    end

    context "when duration_in_years is less than 1" do
      before do
        course.duration_in_years = 0
      end
      it "evaluates to false" do
        expect(course.valid?).to eq false
      end
    end

    context "when duration_in_years is greater than YearStructure.max_year_of_study" do
      before do
        course.duration_in_years = YearStructure.max_year_of_study + 1
      end

      it "evaluates to false" do
        expect(course.valid?).to eq false
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
  
  describe "#all_year_structures_defined?" do
    let! (:year_structure) { create(:year_structure) }
    
    before do
      course.save
      course.year_structures << year_structure
    end

    context "when there is a year structure with no groups" do
      it "evaluates to false" do
        expect(course.all_year_structures_defined?).to eq false
      end
    end

    context "when all year structures have at least one module" do
      before do
        create(:group, year_structure: year_structure, name: "Semester 2")
      end
      it "evaluates to true" do
        expect(course.all_year_structures_defined?).to eq true
      end
    end
  end

  describe "#destroy" do
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

  describe "#to_s" do
    it "returns the name" do
      expect(course.to_s).to eq course.name
    end
  end

  describe ".to_csv" do
    let (:csv_content) { Course.to_csv }
    let (:csv_header) { "name,description,year,duration_in_years,departments\n" }
    let (:department) { create(:department) }

    before do
      course.save
      course.departments << department
    end

    it "outputs all saved courses" do
      expect(csv_content).to include csv_header
      test_csv_attributes_for_all_courses
    end
  end

  private
  def test_csv_attributes_for_all_courses
    courses = Course.all
    csv_content.slice! csv_header
    i = 0
    CSV.parse(csv_content) do |line|
      course = courses[i]
      expect(line).to include course.name
      expect(line).to include course.description
      expect(line).to include course.year.to_s
      expect(line).to include course.duration_in_years.to_s
      course.departments.each do |department|
        expect(line).to include department.to_s
      end
      i += 1
    end
  end
end
