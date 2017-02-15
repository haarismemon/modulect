require 'rails_helper'

RSpec.describe UsersController, type: :controller do


  ## still to test create_by_sign_in
  describe "POST create_by_admin" do
    let (:user) { build(:user) }

    it "should redirect to index with a notice on successful save" do
      allow(user).to receive(:valid?) { true }
      post 'create_by_admin',user: FactoryGirl.attributes_for(:user)
      expect(flash[:notice].present?).to eq true
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

  describe "DELETE destroy"  do

    let (:user) { create(:user) }

    it "retrieves param id and uses it to looks for correct user and then deletes it" do
      delete :destroy,:id => user.id
      expect( assigns[:user].destroyed?).to eq(true)
      expect(flash[:notice].present?).to eq true
      expect(User.all.empty?).to eq true
    end

    it "looks for user using a id that doesnt exist" do
      expect {
        get :edit,:id => -1
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe 'PUT update' do
    let (:user) { create(:user) }

    context "valid attributes" do
      it "located the requested @user" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user)
        expect(assigns(:user)).to eq(user)
      end

      it "changes @users attributes" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user,first_name: "ian",last_name: "mansouri")
        expect(assigns(:user).first_name).to eq "ian"
        expect(assigns(:user).last_name).to eq "mansouri"
      end

      it "redirects back to the list on successful update" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user)
        expect(flash[:notice].present?).to eq true
        expect(response).to redirect_to(users_path)
      end

    end

    context "invalid attributes" do


      it "does not change @user's attributes" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user, year_of_study: "not_a_value", email: nil)
        expect(assigns(:user).year_of_study).not_to eq "not_a_value"
        expect(assigns(:user).email).not_to eq nil
      end

      it "re-renders the edit method" do
        put :update, id: user.id,user: FactoryGirl.attributes_for(:user, year_of_study: "not_a_value", email: nil)
        expect(flash[:notice].present?).to eq false
        expect(response).to render_template("edit")
      end
    end
  end


  describe "GET edit"  do

    let (:user) { create(:user) }

    it "retrieves param id and users it to looks for correct user to store in @user" do
      get :edit,:id => user.id
      expect( assigns[:user].present?).to eq(true)
      expect( assigns[:user].id).to eq(user.id)
    end

    it "renders correct edit template" do
      get :edit,:id => user.id
      expect(response).to render_template("edit")
    end


    it "looks for user using a id that doesnt exist" do
      expect {
        get :edit,:id => -1
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should return status 200' do
      expect(response.status).to eq 200
    end


    it 'should return status 200' do
      expect(response.status).to eq 200
    end
  end

  describe "GET index"  do
    let(:users){User.alphabetically_order_by(:last_name)}

    it "retrieves and assigns ALL users to @users" do
      get :index
      expect(assigns['users']).to eq(users)
    end

    it "renders correct index template" do
      get :index
      expect(response).to render_template("index")
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
