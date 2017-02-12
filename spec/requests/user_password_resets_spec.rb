require 'rails_helper'

RSpec.describe "Public access to password resets", type: :request do

  context "when the user is not activated" do
    let(:user) { build(:user, activated: false, reset_token: User.new_token) }

    it "denies access to #edit" do
      get edit_password_reset_path(user.reset_token)
      expect(response).to redirect_to root_url
    end

    it "denies access to #update" do
      user_attributes = FactoryGirl.attributes_for(:user)
      expect {
        patch password_reset_path(user.reset_token), {user: user_attributes}
      }.to_not change(user, :password_digest)
    end
  end

  context "when an invalid token is given" do
    let (:user) { build(:user, activated: true, reset_token: User.new_token) }

    it "denies access to #edit" do
      get edit_password_reset_path("DEADBEEF")
      expect(response).to redirect_to root_url
    end

    it "denies access to #update" do
      user_attributes = FactoryGirl.attributes_for(:user)
      expect {
        patch password_reset_path(user.reset_token), {user: user_attributes}
      }.to_not change(user, :password_digest)
    end
  end

  context "when the reset token is expired" do
    let (:user) { build(:user, activated: true, reset_token: User.new_token,
                        reset_sent_at: 2.days.ago) }

    it "denies access to #edit" do
      get edit_password_reset_path(user.reset_token)
      expect(response).to redirect_to root_url
    end

    it "denies access to #update" do
      user_attributes = FactoryGirl.attributes_for(:user)
      expect {
        patch password_reset_path(user.reset_token), {user: user_attributes}
      }.to_not change(user, :password_digest)
    end
  end
end
