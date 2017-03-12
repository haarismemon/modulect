require 'rails_helper'
require_relative 'user_controller_spec_helper'

RSpec.configure do |c|
  c.include UserControllerSpecHelper
end

RSpec.describe UsersController, type: :controller do

  ## still to test create_by_sign_in
  describe "POST create_by_admin" do
    let (:user) { build(:user) }

    it "should redirect to index with a notice on successful save" do
      allow(user).to receive(:valid?) { true }
      post 'create_by_admin', user: FactoryGirl.attributes_for(:user)
      expect(flash).not_to be_empty
      expect(response).to redirect_to(users_path)
    end
    #
    it "should re-render new template on failed save" do
      post "create_by_admin", :user =>{:first_name => "Amin"}
      expect(flash[:notice].present?).to eq false
      expect(response).to render_template("new")
    end
    #
    it "should pass params to user" do
      post 'create_by_admin', :user => { :first_name => 'Amin' }
      expect(assigns[:user].first_name).to eq 'Amin'
    end

  end

  describe 'PUT update' do
    let (:user) { create(:user) }

    context "valid attributes" do

      before do
        log_in_as(user)
      end

      it "located the requested @user" do
        put :update, id: user.id, user: FactoryGirl.attributes_for(:user)
        expect(assigns(:user)).to eq(user)
      end

      it "changes @users attributes" do
        put :update, id: user.id,
                    user: FactoryGirl.attributes_for(:user,
                                                      first_name: "ian",
                                                      last_name: "mansouri")
        expect(assigns(:user).valid?).to eq true
      end

      it "redirects to a different page on success" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user)
        expect(flash).not_to be_empty
        expect(response).to have_http_status(:redirect)
      end

    end

    context "invalid attributes" do

      before do
        log_in_as(user)
      end

      it "does not change @user's attributes" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user, year_of_study: "not_a_value", email: nil)
        expect(assigns(:user).year_of_study).not_to eq "not_a_value"
        expect(assigns(:user).email).not_to eq nil
      end

      it "re-renders the edit method" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user, year_of_study: "not_a_value", email: nil)
        expect(flash).not_to be_empty
        expect(response).to have_http_status(:redirect)
      end
    end
  end


  describe "GET edit"  do

    let (:user) { create(:user) }

    before do
      log_in_as(user)
    end

    it "retrieves param id and users it to looks for correct user to store in @user" do
      get :edit, params: {:id => user.id }
      expect( assigns[:user].present?).to eq(true)
      expect( assigns[:user].id).to eq(user.id)
    end

    it "renders correct edit template" do
      get :edit, params: { :id => user.id }
      expect(response).to render_template("edit")
    end

    it 'should return status 200' do
      expect(response.status).to eq 200
    end


    it 'should return status 200' do
      expect(response.status).to eq 200
    end
  end

  describe "GET new"  do
    it "creates a empty new user object and stores it in @user" do
      get :new
      expect(assigns['user'].new_record?).to eq(true)
      expect(assigns['user'].valid?).to eq(false)
    end

    it "renders correct new template" do
      get :new
      expect(response).to render_template("new")
    end

    it 'should return status 200' do
      expect(response.status).to eq 200
    end
  end
end
