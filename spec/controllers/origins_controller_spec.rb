require 'rails_helper'

RSpec.describe OriginsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Origin. As you add validations to Origin, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    #skip("Add a hash of attributes valid for your model")

    valid_attributes = {
      :file_name => 'teste',
      :file_description => 'teste',
      :created_in_sprint => 'teste',
      :updated_in_sprint => 'teste',
      :abbreviation => 'teste',
      :base_type => 'teste',
      :book_mainframe => 'teste',
      :periodicity => 'teste',
      :periodicity_details => 'teste',
      :data_retention_type => 'teste',
      :extractor_file_type => 'teste',
      :room_1_notes => 'teste',
      :mnemonic => 'teste',
      :cd5_portal_origin_code => 'teste',
      :cd5_portal_origin_name => 'teste',
      :cd5_portal_destination_code => 'teste',
      :cd5_portal_destination_name => 'teste',
      :hive_table_name => 'teste',
      :mainframe_storage_type => 'teste',
      :room_2_notes => 'teste',
      :created_at => 'teste',
      :updated_at => 'teste' }

  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # OriginsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all origins as @origins" do
      origin = Origin.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:origins)).to eq([origin])
    end
  end

  describe "GET show" do
    it "assigns the requested origin as @origin" do
      origin = Origin.create! valid_attributes
      get :show, {:id => origin.to_param}, valid_session
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
      origin = Origin.create! valid_attributes
      get :edit, {:id => origin.to_param}, valid_session
      expect(assigns(:origin)).to eq(origin)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Origin" do
        expect {
          post :create, {:origin => valid_attributes}, valid_session
        }.to change(Origin, :count).by(1)
      end

      it "assigns a newly created origin as @origin" do
        post :create, {:origin => valid_attributes}, valid_session
        expect(assigns(:origin)).to be_a(Origin)
        expect(assigns(:origin)).to be_persisted
      end

      it "redirects to the created origin" do
        post :create, {:origin => valid_attributes}, valid_session
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
      let(:new_attributes) {
        #skip("Add a hash of attributes valid for your model")
        new_attributes = {
          :file_name => 'teste',
          :file_description => 'teste',
          :created_in_sprint => 'teste',
          :updated_in_sprint => 'teste',
          :abbreviation => 'teste',
          :base_type => 'teste',
          :book_mainframe => 'teste',
          :periodicity => 'teste',
          :periodicity_details => 'teste',
          :data_retention_type => 'teste',
          :extractor_file_type => 'teste',
          :room_1_notes => 'teste',
          :mnemonic => 'teste',
          :cd5_portal_origin_code => 'teste',
          :cd5_portal_origin_name => 'teste',
          :cd5_portal_destination_code => 'teste',
          :cd5_portal_destination_name => 'teste',
          :hive_table_name => 'teste',
          :mainframe_storage_type => 'teste',
          :room_2_notes => 'teste',
          :created_at => 'teste',
          :updated_at => 'teste' }
      }

      it "updates the requested origin" do
        origin = Origin.create! valid_attributes
        put :update, {:id => origin.to_param, :origin => new_attributes}, valid_session
        origin.reload
        #skip("Add assertions for updated state")
      end

      it "assigns the requested origin as @origin" do
        origin = Origin.create! valid_attributes
        put :update, {:id => origin.to_param, :origin => valid_attributes}, valid_session
        expect(assigns(:origin)).to eq(origin)
      end

      it "redirects to the origin" do
        origin = Origin.create! valid_attributes
        put :update, {:id => origin.to_param, :origin => valid_attributes}, valid_session
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
      origin = Origin.create! valid_attributes
      expect {
        delete :destroy, {:id => origin.to_param}, valid_session
      }.to change(Origin, :count).by(-1)
    end

    it "redirects to the origins list" do
      origin = Origin.create! valid_attributes
      delete :destroy, {:id => origin.to_param}, valid_session
      expect(response).to redirect_to(origins_url)
    end
  end

end
