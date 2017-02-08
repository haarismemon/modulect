require 'rails_helper'

RSpec.describe Tag, type: :model do
  before do
    @tag = Career.new(name: "Finance")
  end

  describe "with a blank name" do
    before do
      @tag.name = ""
    end

    it "is invalid" do
      expect(@tag.valid?).to eq false
    end
  end

  describe "with a non-blank name" do
    it "is valid" do
      expect(@tag.valid?).to eq true
    end
  end
end
