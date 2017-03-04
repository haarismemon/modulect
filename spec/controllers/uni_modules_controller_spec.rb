require 'rails_helper'

RSpec.describe UniModulesController, type: :controller do

  describe "GET #show" do
    let (:uni_module) { create(:uni_module) }

    it "returns http success" do
      get :show, id: uni_module.id
      expect(response).to have_http_status(:success)
    end
  end
end
