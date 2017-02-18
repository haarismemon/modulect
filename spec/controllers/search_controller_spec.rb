require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #home" do
    it "returns http success" do
      get :home
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #view_results" do
    it "redirects when no search params are given" do
      get :view_results
      expect(response).to have_http_status(:redirect)
    end
  end
end
