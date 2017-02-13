require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the SessionsHelper. For example:
#
# describe SessionsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe SessionsHelper, type: :helper do

  let(:user) { create(:user) }

  describe "#log_in" do
    before do
      log_in(user)
    end
    it "stores the user's id into the session hash" do
      expect(session[:user_id]).to eq user.id
      expect(current_user).not_to be_nil
    end
  end

  describe "#logout" do
    it "logs out the user" do
      log_in(user)
      remember(user)
      log_out
      expect(current_user).to be_nil
      expect(session[:user_id]).to be_blank
      expect(cookies.permanent.signed[:user_id]).to be_blank
      expect(cookies.permanent[:remember_token]).to be_blank
    end
  end

  describe "#remember" do
    before do
      remember(user)
    end

    it "stores the user's remember digest into the database" do
      expect(user.remember_digest).not_to be_blank
    end

    it "stores the user's id in a permanent cookie" do
      expect(cookies.permanent.signed[:user_id]).not_to be_blank
      expect(cookies.permanent.signed[:user_id]).to eq user.id
    end

    it "stores the user's remember token in a permanent cookie" do
      expect(cookies.permanent[:remember_token]).not_to be_blank
      expect(cookies.permanent[:remember_token]).to eq user.remember_token
    end

    describe "followed by #forget" do
      before do
        forget(user)
      end

      it "still has the user's remember digest in the database" do
        expect(user.remember_digest).not_to be_blank
      end

      it "removes the user's id from cookies storage" do
        expect(cookies.permanent.signed[:user_id]).to be_blank
      end

      it "removes the user's remember token from cookie storage" do
        expect(cookies.permanent[:remember_token]).to be_blank
      end
    end
  end

  describe "log_out" do
    before do
      log_in(user)
      expect(current_user).not_to be_nil
    end
    it "logs out the currently logged in user" do
      log_out
      expect(session[:user_id]).to be_blank
      expect(current_user).to be_nil
    end
  end

  describe "#current_user" do
    context "when no user is logged in" do
      before do
        log_out
      end
      it "returns nil" do
        expect(current_user).to be_nil
      end
    end

    context "when the user is logged in" do
      before do
        log_in(user)
      end
      it "returns the logged in user" do
        expect(current_user).to eq user
      end
    end
  end

  describe "#logged_in?" do

    context "when no user is logged in" do
      before do
        log_out
      end
      it "returns false" do
        expect(logged_in?).to eq false
      end
    end

    context "when a user is logged in" do
      before do
        log_in(user)
      end
      it "returns true" do
        expect(logged_in?).to eq true
      end
    end
  end
end
