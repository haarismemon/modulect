require 'rails_helper'

RSpec.describe Tagging, type: :model do
  let(:tagging) { build(:tagging) }

  describe "#valid?" do

    context "when both tag_id and uni_module_id are present" do
      it "is true" do
        expect(tagging.valid?).to eq true
      end
    end

    context "when it has a tag_id, but no uni_module_id" do
      before do
        tagging.uni_module_id = nil
      end
      it "is false" do
        expect(tagging.valid?).to eq false
      end
    end

    context "when it has an uni_module_id, but no tag_id" do
      before do
        tagging.tag_id = nil
      end

      it "is false" do
        expect(tagging.valid?).to eq false
      end
    end

  end
end
