require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the UsersHelper. For example:
#
# describe UsersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe UsersHelper, type: :helper do

  let(:user) { build(:user) }

  describe "#full_name_for(user)" do
    it "returns the first name and last name with a space in between" do
      expect(full_name_for(user)).to eq "#{user.first_name} #{user.last_name}"
    end
  end

  describe "#privileges_description_for(user)" do
    context "when the user is a student" do
      before do
        user.user_level = 3
      end
      it "recognizes that the he is a student" do
        expect(privileges_description_for(user)).to eq "Student"
      end
    end

    context "when the user is a department admin" do
      before do
        user.user_level = 2
      end
      it "recognizes that the he is a department admin" do
        expect(privileges_description_for(user)).to eq "Department Administrator"
      end
    end

    context "when the user is a system admin" do
      before do
        user.user_level = 1
      end
      it "recognizes that the he is a system admin" do
        expect(privileges_description_for(user)).to eq "System Administrator"
      end
    end
  end
end
