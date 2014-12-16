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
      :dmt_advice => 'teste',
      :dmt_classification => 'teste',
      :status => 'sala1',
    }
  }

  #let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
  #}

  let(:user_attributes) {
    {
      :email    => "zekitow@gmail.com",
      :name     => "José Ribeiro",
      :profile  => "Sala 1",
      :password => "123456"
    }
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all origins as @origins" do
      origin = Origin.create! valid_attributes
      session[:user_id] = User.create! user_attributes
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
      session[:user_id] = User.create! user_attributes
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
        session[:user_id] = User.create! user_attributes
        expect {
          post :create, {:origin => valid_attributes}, valid_session
        }.to change(Origin, :count).by(1)
      end

      it "assigns a newly created origin as @origin" do
        session[:user_id] = User.create! user_attributes
        post :create, {:origin => valid_attributes}, valid_session
        expect(assigns(:origin)).to be_a(Origin)
        expect(assigns(:origin)).to be_persisted
      end

      it "redirects to the created origin" do
        session[:user_id] = User.create! user_attributes
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
          :file_name => 'teste2',
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
          :dmt_advice => 'teste',
          :dmt_classification => 'teste',
          :status => 'sala1',}
      }


      it "updates the requested origin" do
        origin = Origin.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => origin.to_param, :origin => new_attributes}, valid_session
        origin.reload
        expect(origin.file_name).to eq 'teste2'
      end

      it "assigns the requested origin as @origin" do
        origin = Origin.create! valid_attributes
        put :update, {:id => origin.to_param, :origin => valid_attributes}, valid_session
        expect(assigns(:origin)).to eq(origin)
      end

      it "redirects to the origin" do
        origin = Origin.create! valid_attributes
        session[:user_id] = User.create! user_attributes
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
      session[:user_id] = User.create! user_attributes
      expect {
        delete :destroy, {:id => origin.to_param}, valid_session
      }.to change(Origin, :count).by(-1)
    end

    it "redirects to the origins list" do
      origin = Origin.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      delete :destroy, {:id => origin.to_param}, valid_session
      expect(response).to redirect_to(origins_url)
    end
  end

  let(:valid_origin_field_attributes) {
    valid_origin_field_attributes = {
      :file_name => 'teste2',
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
      :dmt_advice => 'teste',
      :dmt_classification => 'teste',
      :status => 'sala1',
      :origin_id => @origin.id
    }
  }

  describe "POST create origin field" do
    before do
      @origin = Origin.create! valid_attributes
      session[:user_id] = User.create! user_attributes
    end

    describe "with valid params" do
      it "creates or updates an OriginField" do
        expect {
          post :create_or_update_origin_field, {:origin_field => valid_origin_field_attributes}, valid_session
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


  describe "GET origin field" do
    let(:valid_attributes) {
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
        :dmt_advice => 'teste',
        :dmt_classification => 'teste',
        :status => 'sala1',
      }
    }

    let(:valid_origin_field_attributes) {
      valid_origin_field_attributes = {
        :field_name => 'teste',
        :origin_pic => 'teste',
        :data_type => 'teste',
        :decimal => 'teste',
        :mask => 'teste',
        :position => 'teste',
        :width => 'teste',
        :is_key => 'teste',
        :will_use => 'teste',
        :has_signal => 'teste',
        :room_1_notes => 'teste',
        :cd5_variable_number => 'teste',
        :cd5_output_order => 'teste',
        :room_2_notes => 'teste',
        :domain => 'teste',
        :dmt_notes => 'teste',
        :fmbase_format_datyp => 'teste',
        :generic_datyp => 'teste',
        :cd5_origin_frmt_datyp => 'teste',
        :cd5_frmt_origin_desc_datyp => 'teste',
        :default_value_datyp => 'teste',
        :origin_id => 1,
        :created_at => 'teste',
        :updated_at => 'teste'}
    }

    before do
      session[:user_id] = User.create! user_attributes
      @origin = Origin.create! valid_attributes
      @origin_field = OriginField.create! valid_origin_field_attributes
    end

    it "to update" do
      get :get_origin_field_to_update, {:format => @origin_field.id}, valid_session
      expect(response).to render_template("show")
    end
  end


end
