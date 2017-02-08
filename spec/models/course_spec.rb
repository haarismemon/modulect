require 'rails_helper'

RSpec.describe Course, type: :model do

  context "when it is valid" do

    before do
      @course = Course.new(name: "BA Geography")
    end

    it "has a name" do
      @course.name = "BSc Computer Science"
      expect(@course.valid?).to eq true

      @course.name = ""
      expect(@course.valid?).to eq false
    end

    it "has a unique name" do
      @second_course = Course.create(name: "BSc Computer Science")
      expect(@course.valid?).to eq true

      @course.name = "BSc Computer Science"
      expect(@course.valid?).to eq false
    end

  end

end
