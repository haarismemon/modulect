require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #quick_search" do
    it "returns http success" do
      get :quick_search
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #smart_search" do
    it "returns http success" do
      get :smart_search
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #view_results" do
    it "returns http success" do
      get :view_results
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #view_saved" do
    it "returns http success" do
      get :view_saved
      expect(response).to have_http_status(:success)
    end
  end

end
