require 'rails_helper'

RSpec.describe Pathway, type: :model do

  let(:pathway) { build(:pathway) }

  describe "#valid?" do

    context "when name is not present" do
      it "evaluates to true" do
        expect(pathway.valid?).to eq true
      end
    end

    context "when data is blank" do
      before do
        pathway.data = nil
      end
      it "evaluates to false" do
        expect(pathway.valid?).to eq false
      end
    end

  end

end
