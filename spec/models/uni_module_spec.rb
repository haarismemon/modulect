require 'rails_helper'

RSpec.describe UniModule, type: :model do


  context "when it is valid" do
    before do
      @module = UniModule.new(name: "Programming Applications",
                              code: "4CCS1PRA",
                              description: "Really important description",
                              lecturers: "Lela Kouluri, Steven Phelps")



    end
    it "has a name" do
      @module.name = "john"
      expect(@module.valid?).to eq true
      @module.name = ""
      expect(@module.valid?).to eq false
    end

    it "has a code" do
      @module.code = "4ccs1pra"
      expect(@module.valid?).to eq true
      @module.code = ""
      expect(@module.valid?).to eq false
    end

    it "has exactly 8 character long code" do
      @module.code = "4ccs1pra"
      expect(@module.valid?).to eq true
      @module.code = "a" * 7
      expect(@module.valid?).to eq false
    end

    it "has unique code" do
      @second_module = UniModule.create(name: "Programming",
                                     code: "4CCS1PRP",
                                     description: "Learn",
                                     lecturers: "Lela Kouluri")
      @module.code = "4CCS1PRP"
      expect(@module.valid?).to eq false
    end
  end
end
