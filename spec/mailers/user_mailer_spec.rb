require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "account_activation" do
    let (:user) { build(:user, activation_token: User.new_token) }
    let(:mail) { UserMailer.account_activation(user) }

    it "renders the headers" do
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["noreply@modulect.com"])
    end
  end

  describe "password_reset" do
    let (:user) { build(:user, reset_token: User.new_token) }
    let(:mail) { UserMailer.password_reset(user) }

    it "renders the headers" do
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["noreply@modulect.com"])
    end
  end
end
