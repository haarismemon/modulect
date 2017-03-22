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
end
