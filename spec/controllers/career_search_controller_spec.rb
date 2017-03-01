require 'rails_helper'

RSpec.describe CareerSearchController, type: :controller do

  describe "GET #choose" do
    it "returns http success" do
      get :choose
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #view" do
    it "returns http success" do
      get :view
      expect(response).to have_http_status(:success)
    end
  end

end
