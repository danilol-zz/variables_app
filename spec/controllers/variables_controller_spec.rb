require 'rails_helper'

RSpec.describe VariablesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Variable. As you add validations to Variable, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {

    valid_attributes = {
      :name => 'teste',
      :model_field_name => 'teste',
      :data_type => 'teste',
      :width => 'teste',
      :decimal => 'teste',
      :sas_variable_def => 'teste',
      :sas_variable_rule_def => 'teste',
      :sas_update_periodicity => 'teste',
      :domain_type => 'teste',
      :sas_variable_domain => 'teste',
      :variable_type => 'teste',
      :created_in_sprint => 'teste',
      :updated_in_sprint => 'teste',
      :sas_data_model_status => 'teste',
      :drs_bi_diagram_name => 'teste',
      :drs_variable_status => 'teste',
      :room_1_notes => 'teste',
      :default_value => 'teste',
      :room_2_notes => 'teste',
      :owner => 'teste',
      :status => 'teste',
    }
  }

  let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
  }

  let(:user_attributes) {
    {
      :email    => "zekitow@gmail.com",
      :name     => "José Ribeiro",
      :profile  => "Sala 1",
      :password => "123456"
    }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # VariablesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new variable as @variable" do
      session[:user_id] = User.create! user_attributes
      get :new, {}, valid_session
      expect(assigns(:variable)).to be_a_new(Variable)
    end
  end

  describe "GET edit" do
    it "assigns the requested variable as @variable" do
      variable = Variable.create! valid_attributes
      get :edit, {:id => variable.to_param}, valid_session
      expect(assigns(:variable)).to eq(variable)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Variable" do
        session[:user_id] = User.create! user_attributes
        expect {
          post :create, {:variable => valid_attributes}, valid_session
        }.to change(Variable, :count).by(1)
      end

      it "assigns a newly created variable as @variable" do
        session[:user_id] = User.create! user_attributes
        post :create, {:variable => valid_attributes}, valid_session
        expect(assigns(:variable)).to be_a(Variable)
        expect(assigns(:variable)).to be_persisted
        expect(assigns(:variable).status).to eq 'sala1'
      end

      it "redirects to the created variable" do
        session[:user_id] = User.create! user_attributes
        post :create, {:variable => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'variable', notice: 'Variavel criada com sucesso'}))
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved variable as @variable" do
    #    post :create, {:variable => invalid_attributes}, valid_session
    #    expect(assigns(:variable)).to be_a_new(Variable)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:variable => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :name => 'teste',
          :model_field_name => 'teste',
          :data_type => 'teste',
          :width => 'teste',
          :decimal => 'teste',
          :sas_variable_def => 'teste',
          :sas_variable_rule_def => 'teste',
          :sas_update_periodicity => 'teste',
          :domain_type => 'teste',
          :sas_variable_domain => 'teste',
          :variable_type => 'teste',
          :created_in_sprint => 'teste',
          :updated_in_sprint => 'teste',
          :sas_data_model_status => 'teste',
          :drs_bi_diagram_name => 'teste',
          :drs_variable_status => 'teste',
          :room_1_notes => 'teste',
          :default_value => 'teste',
          :room_2_notes => 'teste',
          :owner => 'teste',
          :status => 'teste',
        }
      }

      it "updates the requested variable" do
        variable = Variable.create! valid_attributes
        put :update, {:id => variable.to_param, :variable => new_attributes}, valid_session
        variable.reload
        #skip("Add assertions for updated state")
      end

      it "assigns the requested variable as @variable" do
        variable = Variable.create! valid_attributes
        put :update, {:id => variable.to_param, :variable => valid_attributes}, valid_session
        expect(assigns(:variable)).to eq(variable)
      end

      it "assigns the requested variable as @variable and changes status" do
        session[:user_id] = User.create! user_attributes
        variable = Variable.create! valid_attributes
        put :update, { id: variable.to_param, variable: valid_attributes, update_status: "sala2" }, valid_session
        expect(assigns(:variable)).to eq(variable)
        expect(assigns(:variable).status).to eq 'sala2'
      end

      it "redirects to the variable" do
        variable = Variable.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => variable.to_param, :variable => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'variable', notice: 'Variavel atualizada com sucesso'}))
      end
    end

    #describe "with invalid params" do
    #  it "assigns the variable as @variable" do
    #    variable = Variable.create! valid_attributes
    #    put :update, {:id => variable.to_param, :variable => invalid_attributes}, valid_session
    #    expect(assigns(:variable)).to eq(variable)
    #  end

    #  it "re-renders the 'edit' template" do
    #    variable = Variable.create! valid_attributes
    #    put :update, {:id => variable.to_param, :variable => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
  end
end
