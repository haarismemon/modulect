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

    let (:valid_tag) { create(:tag) }

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
end
