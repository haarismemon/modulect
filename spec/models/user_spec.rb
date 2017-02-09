require 'rails_helper'

RSpec.describe User, type: :model do
  context "when it is valid" do
    before do
      @user = User.new(first_name: "Allison",
                       last_name: "Wonderland",
                       email: "allison_wonderland@eemail.com",
                       username: "allisonBurgers",
                       password_digest: "password",
                       user_level: 3,
                       entered_before: false,
                       year_of_study: 2)



    end
    it "has a first name" do
      @user.first_name = "fname"
      expect(@user.valid?).to eq true
      @user.first_name = ""
      expect(@user.valid?).to eq false
    end

    it "has a last name" do
      @user.last_name = "lname"
      expect(@user.valid?).to eq true
      @user.last_name = ""
      expect(@user.valid?).to eq false
    end

    it "has an email" do
      @user.email = "o@l.com"
      expect(@user.valid?).to eq true
      @user2 = User.create(first_name: "Allison",
                       last_name: "Wonderland",
                       email: "efw@rfew.com",
                       username: "allisonBurgers",
                       password_digest: "password",
                       user_level: 3,
                       entered_before: false,
                       year_of_study: 2)
      @user.email = "efw@rfew.com"
      expect(@user.valid?).to eq false
    end

    it "has a username" do
      @user.username = "itsme"
      expect(@user.valid?).to eq true
      @user.username = ""
      expect(@user.valid?).to eq false
    end

    it "has a password" do
      @user.password_digest = "pasworddd"
      expect(@user.valid?).to eq true
      @user.password_digest = ""
      expect(@user.valid?).to eq false
    end

    it "has a user_level" do
      @user.user_level = 2
      expect(@user.valid?).to eq true
      @user.user_level = 222
      expect(@user.valid?).to eq false
    end

    it "has a year of study" do
      @user.year_of_study = 1
      expect(@user.valid?).to eq true
      @user.year_of_study = 321
      expect(@user.valid?).to eq false
    end
  end
end
