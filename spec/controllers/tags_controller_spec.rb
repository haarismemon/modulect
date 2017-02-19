require 'rails_helper'

RSpec.describe TagsController, type: :controller do

  describe "POST create" do
    let (:tag) { build(:tag) }

    it "should redirect to index with a notice on successful save" do
      allow(tag).to receive(:valid?) { true }
      post 'create', tag: FactoryGirl.attributes_for(:tag)
      expect(flash[:notice].present?).to eq true
      expect(response).to redirect_to(tags_path)
    end

    it "should re-render new template on failed save" do
      post "create", :tag =>{:name => "Fun"}
      expect(flash[:notice].present?).to eq false
      expect(response).to render_template("new")
    end
    #
    it "should pass params to tags" do
      post 'create', :tag => { :name => 'Fun',:type =>"CareerTag" }
      expect(assigns[:tag].name).to eq 'Fun'
    end

  end

  describe "DELETE destroy"  do

    let (:tag) { create(:tag) }

    it "retrieves param id and uses it to looks for correct tag and then deletes it" do
      delete :destroy, params: { :id => tag.id }
      expect( assigns[:tag].destroyed?).to eq(true)
      expect(flash[:notice].present?).to eq true
      expect(Tag.all.empty?).to eq true
    end

    it "looks for tag using a id that doesnt exist" do
      expect {
        get :edit, params: { :id => -1 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  describe 'PUT update' do
    let (:tag) { create(:tag) }

    context "valid attributes" do
      it "located the requested @tag" do
        put :update, id: tag.id,tag: FactoryGirl.attributes_for(:tag)
        expect(assigns(:tag).name).to eq(tag.name)
      end

      it "changes @tags attributes" do
        put :update, id: tag.id,tag: FactoryGirl.attributes_for(:tag,name: "teacher",type: "CareerTag")
        expect(assigns(:tag).name).to eq "teacher"
        expect(assigns(:tag).type).to eq "CareerTag"
      end

      it "redirects back to the list on successful update" do
        put :update, id: tag.id,tag: FactoryGirl.attributes_for(:tag)
        expect(flash[:notice].present?).to eq true
        expect(response).to have_http_status(:redirect)
      end

    end

    context "invalid attributes" do

      it "does not change @tag's attributes" do
        put :update, id: tag.id, tag: FactoryGirl.attributes_for(:tag, name: nil, type:"module")
        expect(assigns(:tag).valid?).to eq false
      end

      it "re-renders the edit method" do
        put :update, id: tag.id,tag: FactoryGirl.attributes_for(:tag, name: nil, type:"module")
        expect(flash[:notice].present?).to eq false
        expect(response).to render_template("edit")
      end
    end
  end


  describe "GET edit"  do

    let (:tag) { create(:tag) }

    it "retrieves param id and tags it to looks for correct tag to store in @tag" do
      get :edit, params: { :id => tag.id }
      expect( assigns[:tag].present?).to eq(true)
      expect( assigns[:tag].id).to eq(tag.id)
    end

    it "renders correct edit template" do
      get :edit, params: { :id => tag.id }
      expect(response).to render_template("edit")
    end


    it "looks for tag using a id that doesnt exist" do
      expect {
        get :edit, params: { :id => -1 }
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
    let(:tags) { Tag.alphabetically_order_by(:name) }

    it "retrieves and assigns ALL tags to @tags" do
      get :index
      expect(assigns['tags'].name).to eq(tags.name)
    end

    it "renders correct index template" do
      get :index
      expect(response).to render_template("index")
    end
  end


  describe "GET new"  do
    it "creates a empty new tag object and stores it in @tag" do
      get :new
      expect(assigns['tag'].new_record?).to eq(true)
      expect(assigns['tag'].valid?).to eq(false)
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
