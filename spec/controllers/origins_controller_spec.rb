require 'rails_helper'

RSpec.describe OriginsController, type: :controller do

  before do
    session[:user_id] = User.create(user_attributes)
  end

  # This should return the minimal set of attributes required to create a valid
  # Origin. As you add validations to Origin, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { FactoryGirl.attributes_for(:origin) }
  let(:user_attributes)  { FactoryGirl.attributes_for(:user) }
  let(:valid_session)    { {} }

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

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved origin as @origin" do
    #    post :create, {:origin => invalid_attributes}, valid_session
    #    expect(assigns(:origin)).to be_a_new(Origin)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:origin => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
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

    #describe "with invalid params" do
    #  it "assigns the origin as @origin" do
    #    origin = Origin.create! valid_attributes
    #    put :update, {:id => origin.to_param, :origin => invalid_attributes}, valid_session
    #    expect(assigns(:origin)).to eq(origin)
    #  end

    #  it "re-renders the 'edit' template" do
    #    origin = Origin.create! valid_attributes
    #    put :update, {:id => origin.to_param, :origin => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
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
      it "creates a new OriginField" do
        expect { post :create_origin_field, { origin_field: valid_origin_field_attributes }, valid_session }.to change(OriginField, :count).by(1)
      end

      it "assigns a newly created origin_field as @origin_field" do
        post :create_origin_field, { origin_field: valid_origin_field_attributes }, valid_session

        expect(assigns(:origin_field)).to be_a(OriginField)
        expect(assigns(:origin_field)).to be_persisted
      end

      it "redirects to the created origin_field" do
        post :create_origin_field, { origin_field: valid_origin_field_attributes }, valid_session

        expect(response).to redirect_to(@origin)
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved origin_field as @origin_field" do
    #    post :create, {:origin_field => invalid_attributes}, valid_session
    #    expect(assigns(:origin_field)).to be_a_new(OriginField)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:origin_field => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
  end
end
