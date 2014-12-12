require 'rails_helper'

RSpec.describe OriginFieldsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # OriginField. As you add validations to OriginField, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    valid_attributes = {
      :field_name => 'teste',
      :origin_pic => 'teste',
      :data_type => 'teste',
      :fmbase_format_type => 'teste',
      :generic_data_type => 'teste',
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
      :cd5_variable_name => 'teste',
      :cd5_origin_format => 'teste',
      :cd5_origin_format_desc => 'teste',
      :cd5_format => 'teste',
      :cd5_format_desc => 'teste',
      :default_value => 'teste',
      :room_2_notes => 'teste',
      :domain => 'teste',
      :dmt_notes => 'teste',
      :origin_id => 'teste',
      :created_at => 'teste',
      :updated_at => 'teste', }
  }

  let(:user_attributes) {
    {
      :email    => "zekitow@gmail.com",
      :name     => "José Ribeiro",
      :profile  => "Sala 1",
      :password => "123456"
    }
  }

  let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all origin_fields as @origin_fields" do
      origin_field = OriginField.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      get :index, {}, valid_session
      expect(assigns(:origin_fields)).to eq([origin_field])
    end
  end

  describe "GET show" do
    it "assigns the requested origin_field as @origin_field" do
      origin_field = OriginField.create! valid_attributes
      get :show, {:id => origin_field.to_param}, valid_session
      expect(assigns(:origin_field)).to eq(origin_field)
    end
  end

  describe "GET new" do
    it "assigns a new origin_field as @origin_field" do
      session[:user_id] = User.create! user_attributes
      get :new, {}, valid_session
      expect(assigns(:origin_field)).to be_a_new(OriginField)
    end
  end

  describe "GET edit" do
    it "assigns the requested origin_field as @origin_field" do
      origin_field = OriginField.create! valid_attributes
      get :edit, {:id => origin_field.to_param}, valid_session
      expect(assigns(:origin_field)).to eq(origin_field)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      xit "creates a new OriginField" do
        session[:user_id] = User.create! user_attributes
        expect {
          post :create, {:origin_field => valid_attributes}, valid_session
        }.to change(OriginField, :count).by(1)
      end

      xit "assigns a newly created origin_field as @origin_field" do
        session[:user_id] = User.create! user_attributes
        post :create, {:origin_field => valid_attributes}, valid_session
        expect(assigns(:origin_field)).to be_a(OriginField)
        expect(assigns(:origin_field)).to be_persisted
      end

      xit "redirects to the created origin_field" do
        session[:user_id] = User.create! user_attributes
        post :create, {:origin_field => valid_attributes}, valid_session
        expect(response).to redirect_to(OriginField.last)
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

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :field_name => 'teste_updated',
          :origin_pic => 'teste',
          :data_type => 'teste',
          :fmbase_format_type => 'teste',
          :generic_data_type => 'teste',
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
          :cd5_variable_name => 'teste',
          :cd5_origin_format => 'teste',
          :cd5_origin_format_desc => 'teste',
          :cd5_format => 'teste',
          :cd5_format_desc => 'teste',
          :default_value => 'teste',
          :room_2_notes => 'teste',
          :domain => 'teste',
          :dmt_notes => 'teste',
          :origin_id => 'teste',
          :created_at => 'teste',
          :updated_at => 'teste', }
      }

      it "updates the requested origin_field" do
        origin_field = OriginField.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => origin_field.to_param, :origin_field => new_attributes}, valid_session
        origin_field.reload
        expect(origin_field.field_name).to eq ("teste_updated")
      end

      it "assigns the requested origin_field as @origin_field" do
        origin_field = OriginField.create! valid_attributes
        put :update, {:id => origin_field.to_param, :origin_field => valid_attributes}, valid_session
        expect(assigns(:origin_field)).to eq(origin_field)
      end

      it "redirects to the origin_field" do
        origin_field = OriginField.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => origin_field.to_param, :origin_field => valid_attributes}, valid_session
        expect(response).to redirect_to(origin_field)
      end
    end

    #describe "with invalid params" do
    #  it "assigns the origin_field as @origin_field" do
    #    origin_field = OriginField.create! valid_attributes
    #    put :update, {:id => origin_field.to_param, :origin_field => invalid_attributes}, valid_session
    #    expect(assigns(:origin_field)).to eq(origin_field)
    #  end

    #  it "re-renders the 'edit' template" do
    #    origin_field = OriginField.create! valid_attributes
    #    put :update, {:id => origin_field.to_param, :origin_field => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
  end

  describe "DELETE destroy" do
    it "destroys the requested origin_field" do
      origin_field = OriginField.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      expect {
        delete :destroy, {:id => origin_field.to_param}, valid_session
      }.to change(OriginField, :count).by(-1)
    end

    it "redirects to the origin_fields list" do
      origin_field = OriginField.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      delete :destroy, {:id => origin_field.to_param}, valid_session
      expect(response).to redirect_to(origin_fields_url)
    end
  end
end
