require 'rails_helper'

RSpec.describe CareerSearchController, type: :controller do

  describe "GET #choose" do
    it "returns http success" do
      get :choose
      expect(response).to redirect_to(career_search_path)
    end
  end

end
