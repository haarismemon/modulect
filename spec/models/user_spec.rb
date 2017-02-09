require 'rails_helper'

RSpec.describe User, type: :model do

  describe "#valid?" do

    let(:user) { build(:user) }

    context "when all fields are valid" do
      it "evaluates to true" do
        expect(user.valid?).to eq true
      end
    end

    context "when first name is blank" do
      before do
        user.first_name = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when last name is blank" do
      before do
        user.last_name = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when first name is longer than 70 characters" do
      before do
        user.first_name = "a" * 71
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when last name is longer than 70 characters" do
      before do
        user.last_name = "a" * 71
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is blank" do
      before do
        user.email = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is of wrong format" do
      let(:invalid_emails) { %w(foo foo@bar foo@.bar
                               foo@bar.123 foo@bar..baz
                               foo.bar@baz @foo.bar) }
      it "evaluates to false" do
        invalid_emails.each do |email|
          user.email = email
          expect(user.valid?).to eq false
        end
      end
    end

    context "when email is already taken" do
      before do
        create(:user, email: user.email)
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when email is longer than 255 characters" do
      before do
        user.email = "a" * 256
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when username is blank" do
      before do
        user.username = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when username is already taken" do
      before do
        create(:user, username: user.username)
      end
      it "evaluates to false" do
        expect(user.valid?). to eq false
      end
    end

    context "when user_level is one digit long" do
      context "but not 1|2|3" do
        before do
          user.user_level = 4
        end
        it "evaluates to false" do
          expect(user.valid?).to eq false
        end
      end
    end

    context "when user_level is longer than one digit" do
      before do
        user.user_level = 11
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when year_of_study is one digit long" do
      context "and is one of 1|2|3|4|5|6" do
        before do
          user.year_of_study = 1
        end
        it "evaluates to true" do
          expect(user.valid?).to eq true
        end
      end

      context "and is not one of 1|2|3|4|5|6" do
        before do
          user.year_of_study = 7
        end
        it "evaluates to false" do
          expect(user.valid?).to eq false
        end
      end
    end

    context "when year_of_study is blank" do
      before do
        user.year_of_study = nil
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end

    context "when year_of_study is longer than one digit" do
      before do
        user.year_of_study = 10
      end
      it "evaluates to false" do
        expect(user.valid?).to eq false
      end
    end
  end
end
