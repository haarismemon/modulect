require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #quick_search" do
    it "returns http success" do
      get :quick_search
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #pathway_search" do
    it "returns http success" do
      get :pathway_search
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #view_results" do
    it "redirects when no search params are given" do
      get :view_results
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #view_saved" do
    context "when not logged in" do
      it "redirects to another page" do
        get :view_saved
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
