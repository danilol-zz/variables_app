require 'rails_helper'

RSpec.describe OriginsController, type: :controller do

  before do
    session[:user_id] = User.create(user_attributes)
  end

  # This should return the minimal set of attributes required to create a valid
  # Origin. As you add validations to Origin, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes)                { FactoryGirl.attributes_for(:origin) }
  let(:user_attributes)                 { FactoryGirl.attributes_for(:user) }
  let(:valid_session)                   { {} }

  describe "GET index" do
    it "assigns all origins as @origins" do
      origin = Origin.create(valid_attributes)

      get :index, {}, valid_session

      expect(assigns(:origins)).to eq([origin])
    end
  end

  describe "GET show" do
    it "assigns the requested origin as @origin" do
      origin = Origin.create(valid_attributes)

      get :show, { id: origin.to_param }, valid_session

      expect(assigns(:origin)).to eq(origin)
    end
  end

  describe "GET new" do
    it "assigns a new origin as @origin" do
      get :new, {}, valid_session

      expect(assigns(:origin)).to be_a_new(Origin)
    end
  end

  describe "GET edit" do
    it "assigns the requested origin as @origin" do
      origin = Origin.create(valid_attributes)

      get :edit, { id: origin.to_param }, valid_session

      expect(assigns(:origin)).to eq(origin)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Origin" do
        expect { post :create, { origin: valid_attributes}, valid_session }.to change(Origin, :count).by(1)
      end

      it "assigns a newly created origin as @origin" do
        post :create, { origin: valid_attributes }, valid_session

        expect(assigns(:origin)).to be_a(Origin)
        expect(assigns(:origin)).to be_persisted
      end

      it "redirects to the created origin" do
        post :create, { origin: valid_attributes }, valid_session

        expect(response).to redirect_to(Origin.last)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) { FactoryGirl.attributes_for(:origin, file_name: 'teste2') }

      it "updates the requested origin" do
        origin = Origin.create(valid_attributes)

        put :update, { id: origin.to_param, origin: new_attributes }, valid_session

        origin.reload

        expect(origin.file_name).to eq 'teste2'
      end

      it "assigns the requested origin as @origin" do
        origin = Origin.create(valid_attributes)

        put :update, { id: origin.to_param, origin: valid_attributes }, valid_session

        expect(assigns(:origin)).to eq(origin)
      end

      it "redirects to the origin" do
        origin = Origin.create(valid_attributes)

        put :update, { id: origin.to_param, origin: valid_attributes }, valid_session

        expect(response).to redirect_to(origin)
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested origin" do
      origin = Origin.create(valid_attributes)

      expect { delete :destroy, { id: origin.to_param }, valid_session }.to change(Origin, :count).by(-1)
    end

    it "redirects to the origins list" do
      origin = Origin.create! valid_attributes

      delete :destroy, { id: origin.to_param }, valid_session

      expect(response).to redirect_to(origins_url)
    end
  end

  let(:valid_origin_field_attributes) { FactoryGirl.attributes_for(:origin, origin_id: @origin.id) }

  describe "POST create origin field" do
    before do
      @origin  = Origin.create! valid_attributes
    end

    describe "with valid params" do
      it "creates or updates an OriginField" do
        expect {
          post :create_or_update_origin_field, 
            {:origin_field => valid_origin_field_attributes.merge(:origin_id => @origin.id) }, 
            valid_session
        }.to change(OriginField, :count).by(1)
      end

      it "assigns a newly created origin_field as @origin_field" do
        post :create_or_update_origin_field, {:origin_field => valid_origin_field_attributes}, valid_session

        expect(assigns(:origin_field)).to be_a(OriginField)
        expect(assigns(:origin_field)).to be_persisted
      end

      it "redirects to the created origin_field" do
        post :create_or_update_origin_field, {:origin_field => valid_origin_field_attributes}, valid_session

        expect(response).to redirect_to(@origin)
      end
    end
  end

  let(:valid_origin_field_attributes)   { FactoryGirl.attributes_for(:origin_field) }

  describe "GET origin field" do
    before do
      @origin = Origin.create! valid_attributes
      @origin_field = OriginField.create! valid_origin_field_attributes
    end

    it "to update" do
      get :get_origin_field_to_update, {:format => @origin_field.id}, valid_session
      expect(response).to render_template("show")
    end
  end

  describe "DELETE origin field" do
    before do
      @origin = Origin.create! valid_attributes
      @origin_field = OriginField.create! valid_origin_field_attributes
    end
    it "to destroy" do
      expect{
        delete :destroy_origin_field, {:format => @origin_field.id}, valid_session
        }.to change(OriginField, :count).by(-1)
    end
  end


end
