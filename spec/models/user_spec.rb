require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { build(:user) }

  describe "when created into the database" do
    before do
      user.save
    end
    it "has an activation token" do
      expect(user.activation_token).not_to be_blank
    end
    it "has an activation digest" do
      expect(user.activation_digest).not_to be_blank
    end
    it "has a matching token for the digest" do
        expect(user.authenticated?(:activation,
                                    user.activation_token
                                    )).to eq true
    end
  end

  describe "#department" do
    context "when user is a department admin" do
      before do
        user.department = build(:department)
      end

      it "returns the department" do
        expect(user.department).not_to be_nil
      end
    end

    context "when user is not a department admin" do
      it "returns nil" do
        expect(user.department).to be_nil
      end
    end
  end

  describe "#department_admin?" do
    context "when user is a department admin" do
      before do
        user.user_level = :department_admin_access
        user.department = build(:department)
      end

      it "returns true" do
        expect(user.department_admin?).to eq true
      end
    end

    context "when user is not a department admin" do
      before do
        user.user_level = :user_access
      end

      it "returns false" do
        expect(user.department_admin?).to eq false
      end
    end
  end

  describe "before save" do
    context "when email contains capital letters" do
      before do
        user.email.upcase!
        user.save
      end
      it "downcases email" do
        expect(user.email).to eq user.email.downcase
      end
    end
  end

  describe "#remember" do
    before do
      user.update_attribute(:remember_digest, nil)
      user.remember
    end

    it "generates and saves a unique remember_token for the user" do
      expect(user.remember_token).not_to be_blank
    end

    it "generates and saves a digest of the user's unique remember token" do
      expect(user.remember_digest).not_to be_blank
    end
  end

  describe "#forget" do
    before do
      user.remember
      expect(user.remember_token).not_to be_blank
    end

    it "forgets the user's remember token" do
      user.forget
      expect(user.remember_token).to be_blank
    end
  end

  describe "#authenticated?" do
    before do
      user.remember
    end

    context "when checking if a user is a remembered user" do
      context "and the user's remember_token is passed" do
        it "returns true" do
          expect(user.authenticated?(:remember,
                                      user.remember_token
                                      )).to eq true
        end
      end

      context "and an incorrect remember_token is passed" do
        it "returns false" do
          expect(user.authenticated?(:remember, "DEADBEEF")).to eq false
        end
      end
    end
  end

  describe "#is_password?" do
    context "when passed the correct password" do
      it "evaluates to true" do
        expect(user.is_password?('password')).to eq true
      end
    end

    context "when passed the wrong password" do
      it "evaluates to false" do
        expect(user.is_password?('invalid')).to eq false
      end
    end
  end

  describe "#valid?" do

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

    context "when year_of_study is one digit long" do
      before do
        user.year_of_study = 1
      end
      it "evaluates to true" do
        expect(user.valid?).to eq true
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

  describe "assigning user privileges" do
    context "when giving super admin access" do
      before do
        user.super_admin_access!
      end
      it "gives the user admin access" do
        expect(user.super_admin_access?).to eq true
      end
    end

    context "when giving department admin access" do
      before do
        user.department_admin_access!
      end
      it "gives the user admin access to the department" do
        expect(user.department_admin_access?).to eq true
      end
    end

    context "when giving regular user access" do
      before do
        user.user_access!
      end
      it "gives the user regular access" do
        expect(user.user_access?).to eq true
      end
    end
  end

  describe "#reset" do

    context "when resetting single value attributes" do

      before do
        user.reset
      end

      it "changes the year of study to nil" do
        expect(user.year_of_study).to be_nil
      end

      it "changes the faculty to nil" do
        expect(user.faculty).to be_nil
      end

      it "changes the department to nil" do
        expect(user.department).to be_nil
      end

      it "changes the course id to nil" do
        expect(user.course).to be_nil
      end
    end

    context "when resetting has_many attributes" do
      before do
        user.pathways << build(:pathway)
        user.uni_modules << build(:uni_module)
        user.reset
      end

      it "changes the selected modules to blank" do
        expect(user.uni_modules).to be_blank
      end

      it "changes the pathways to blank" do
        expect(user.pathways).to be_blank
      end
    end
  end

  describe "#save_module" do
    let(:valid_uni_module) { create(:uni_module) }

    context "when passed a valid uni_module" do
      before do
        user.save
        user.save_module(valid_uni_module)
      end

      it "registers the uni modules as having been saved" do
        expect(user.uni_modules.include?(valid_uni_module)).to eq true
      end
    end
  end

  describe "#unsave_module" do
    let(:valid_uni_module) { create(:uni_module) }

    context "when passed a valid uni_module" do
      before do
        user.save
        user.unsave_module(valid_uni_module)
      end

      it "registers the uni modules as having been saved" do
        expect(user.uni_modules.exclude?(valid_uni_module)).to eq true
      end
    end
  end

  describe "activate" do
    before do
      user.update_attributes(activated: false, activated_at: nil)
    end

    it "sets the activated columns" do
      user.activate
      expect(user.activated?).to eq true
      expect(user.activated_at).not_to be_nil
    end
  end

  describe "#create_reset_digest" do
    before do
      user.save
      user.create_reset_digest
    end

    it "sets the reset_digest and reset_sent_at" do
      expect(user.reset_digest).not_to be_nil
      expect(user.reset_sent_at).not_to be_nil
    end
  end

  describe "#password_reset_expired?" do
    before do
      user.save
      user.create_reset_digest
    end

    context "when the reset request has just been made" do
      it "evaluates to false" do
        expect(user.password_reset_expired?).to eq false
      end
    end

    context "when the reset digest is older than 2 hours" do
      before do
        user.update_attributes(reset_sent_at: 3.hours.ago)
      end
      it "evaluates to true" do
        expect(user.password_reset_expired?).to eq true
      end
    end
  end

  describe ".to_csv" do
    let! (:course) { create(:course) }
    let! (:department) { create(:department) }
    let! (:user1) { create(:user, faculty: department.faculty, course_id: course.id, department_id: department.id) }
    let! (:user2) { create(:user, first_name: "John", last_name: "Sonmez", email: "john.sonmez@kcl.ac.uk") }
    let (:csv_content) { User.to_csv }
    let (:csv_header) { "First Name,Last Name,User level,Faculty,Department,Course,Year of study\n" }

    it "outputs all saved users" do
      expect(csv_content).to include csv_header
      test_csv_attributes_for_all_users
    end
  end

  private
  def test_csv_attributes_for_all_users
    users = User.all
    csv_content.slice!(csv_header)
    i = 0
    CSV.parse(csv_content).each do |line|
      line = line.join(",")
      user = users[i]
      expect(line).to include user.first_name
      expect(line).to include user.last_name
      expect(line).to include user.faculty.to_s
      expect(line).to include user.course.to_s
      expect(line).to include user.department.to_s
      i += 1
    end
  end
end
