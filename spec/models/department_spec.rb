require 'rails_helper'

RSpec.describe Department, type: :model do

  context "when it is valid" do

    before do
      @department = Department.new(name: "Mathematics")
    end

    it "has a name" do
      @department.name = "Informatics"
      expect(@department.valid?).to eq true

      @department.name = ""
      expect(@department.valid?).to eq false
    end

    it "has a unique name" do
      @second_department = Department.create(name: "Informatics")
      expect(@department.valid?).to eq true

      @department.name = "Informatics"
      expect(@department.valid?).to eq false
    end

  end

end
