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
      :origin_id => 'teste',
      :created_at => 'teste',
      :updated_at => 'teste'}
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

  describe "GET show" do
    it "assigns the requested origin_field as @origin_field" do
      origin_field = OriginField.create! valid_attributes
      get :show, {:id => origin_field.to_param}, valid_session
      expect(assigns(:origin_field)).to eq(origin_field)
    end
  end

  describe "GET edit" do
    it "assigns the requested origin_field as @origin_field" do
      origin_field = OriginField.create! valid_attributes
      get :edit, {:id => origin_field.to_param}, valid_session
      expect(assigns(:origin_field)).to eq(origin_field)
    end
  end


  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :field_name => 'teste_updated',
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
          :origin_id => 'teste',
          :created_at => 'teste',
          :updated_at => 'teste' }
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
