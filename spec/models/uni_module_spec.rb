require 'rails_helper'

RSpec.describe UniModule, type: :model do

  let(:uni_module) { build(:uni_module) }

  describe "#valid?" do

    context "when all fields are valid" do
      it "evaluates to true" do
        expect(uni_module.valid?).to eq true
      end
    end

    context "when name is present" do
      context "and not unique" do
        before do
          create(:uni_module, name: uni_module.name)
        end
        it "evaluates to false" do
          expect(uni_module.valid?).to eq false
        end
      end
    end

    context "when code is present" do
      context "and is 8 digits long" do
        it "evaluates to true" do
          expect(uni_module.valid?).to eq true
        end
      end

      context "and not unique" do
        before do
          create(:uni_module, code: uni_module.code)
        end
        it "evaluates to false" do
          expect(uni_module.valid?).to eq false
        end
      end

      context "and not 8 digits long" do
        before do
          uni_module.code = "a" * 7
        end
        it "evaluates to false" do
          expect(uni_module.valid?).to eq false
        end
      end
    end
  end

  describe "#add_tag" do

    let(:valid_tag) { create(:tag) }

    context "when passed a valid tag" do

      before do
        uni_module.save
        uni_module.add_tag(valid_tag)
      end

      it "adds the tag to the module's list of tags" do
        expect(uni_module.tags.include?(valid_tag)).to eq true
      end
    end
  end

  describe "#select_by_user" do
    let(:valid_user) { create(:user) }

    context "when passed a valid user" do
      before do
        uni_module.save
        uni_module.select_by_user(valid_user)
      end

      it "records the user as having selected this module" do
        expect(uni_module.users.include?(valid_user)).to eq true
      end
    end
  end

  describe ".to_csv" do
    let! (:course) { create(:course) }
    let! (:department) { create(:department) }
    let!(:career_tag) { create(:career_tag) }
    let!(:interest_tag) { create(:interest_tag) }
    let! (:module1) { create(:uni_module) }
    let! (:module2) { create(:uni_module, 
                              name: "Philosophy and Geography",
                              code: "4LAB1PHG",
                              semester: "2",
                              credits: 15,
                              )}
    let (:csv_header) { "name,code,description,lecturers,pass_rate,assessment_methods,semester,credits,exam_percentage,coursework_percentage,more_info_link,assessment_dates,prerequisite_modules,career_tags,interest_tags,departments\n" }
    let (:csv_content) { UniModule.to_csv(UniModule.all) }

    before do
      module2.uni_modules << module1
      module2.career_tags << career_tag
      module2.interest_tags << interest_tag
    end
   
    it "outputs all saved modules" do
      expect(csv_content).to include csv_header
      test_csv_attributes_for_all_uni_modules
    end
  end

  private
  def test_csv_attributes_for_all_uni_modules
    uni_modules = UniModule.all
    csv_content.slice!(csv_header)
    i = 0
    CSV.parse(csv_content).each do |line|
      line = line.join(",")
      uni_module = uni_modules[i]
      expect(line).to include uni_module.name
      expect(line).to include uni_module.code
      expect(line).to include uni_module.semester
      expect(line).to include uni_module.credits.to_s
      uni_module.uni_modules.each do |prerequisite_module|
        expect(line).to include prerequisite_module.code
      end
      uni_module.career_tags.each do |career_tag|
        expect(line).to include career_tag.name
      end
      uni_module.interest_tags.each do |interest_tag|
        expect(line).to include interest_tag.name
      end
      i += 1
    end
  end
end
