require 'rails_helper'

RSpec.describe VariablesController, :type => :controller do
  before { session[:user_id] = current_user_id }

  let(:current_user_id)  { User.create(user_attributes).id }
  let(:valid_attributes) { FactoryGirl.attributes_for(:variable, current_user_id: current_user_id) }
  let(:user_attributes)  { FactoryGirl.attributes_for(:user) }
  let(:valid_session)    { {} }

  describe "GET index" do
    let(:variable) { Variable.create(valid_attributes) }

    it "assigns all variables as @variables" do
      get :index, {}, valid_session
      expect(assigns(:variables)).to eq([variable])
    end
  end

  describe "GET search" do
    before do
      @variable1 = FactoryGirl.create(:variable, name: "name01", current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
      @variable2 = FactoryGirl.create(:variable, name: "name02", current_user_id: current_user_id, status: Constants::STATUS[:SALA2])
      @variable3 = FactoryGirl.create(:variable, name: "name3",  current_user_id: current_user_id, status: Constants::STATUS[:PRODUCAO])
      @variable4 = FactoryGirl.create(:variable, name: "name4",  current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
    end

    context "with invalid params" do
      context "when no params is sent" do
        it 'returns all records' do
          post :search, valid_session
          expect(assigns(:variables)).to eq([@variable1, @variable2, @variable3, @variable4])
          expect(response).to render_template("index")
        end
      end

      context "when params is blank" do
        it 'returns all records' do
          post :search, { text_param: "", status_param: "" }, valid_session
          expect(assigns(:variables)).to eq([@variable1, @variable2, @variable3, @variable4])
          expect(response).to render_template("index")
        end
      end
    end

    context "with valid params" do
      subject { post :search, { text_param: file, status_param: status }, valid_session }

      context "with only text param" do
        context "with no existent name" do
          let(:file)   { "invalid" }
          let(:status) { "" }

          it 'returns no records' do
            subject
            expect(assigns(:variables)).to eq([])
          end
        end

        context "with part of existent name" do
          let(:file)   { 'name0' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:variables)).to eq([@variable1, @variable2])
          end
        end

        context "with exactly the same name" do
          let(:file)   { 'name3' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:variables)).to eq([@variable3])
          end
        end
      end

      context "with only status param" do
        let(:file)   { '' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:variables)).to eq([@variable1, @variable4])
        end
      end

      context "with both params" do
        let(:file)   { 'name0' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:variables)).to eq([@variable1])
          expect(response).to render_template("index")
        end
      end
    end
  end
  describe "GET new" do
    it "assigns a new variable as @variable" do
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
        expect {
          post :create, {:variable => valid_attributes}, valid_session
        }.to change(Variable, :count).by(1)
      end

      it "assigns a newly created variable as @variable" do
        post :create, {:variable => valid_attributes}, valid_session
        expect(assigns(:variable)).to be_a(Variable)
        expect(assigns(:variable)).to be_persisted
        expect(assigns(:variable).status).to eq 'sala1'
      end

      it "redirects to the created variable" do
        post :create, {:variable => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'variable', notice: 'Variável criada com sucesso'}))
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
        variable = Variable.create! valid_attributes
        put :update, { id: variable.to_param, variable: valid_attributes, update_status: "sala2" }, valid_session
        expect(assigns(:variable)).to eq(variable)
        expect(assigns(:variable).status).to eq 'sala2'
      end

      it "redirects to the variable" do
        variable = Variable.create! valid_attributes
        put :update, {:id => variable.to_param, :variable => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'variable', notice: 'Variável atualizada com sucesso'}))
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

  describe "GET name search" do
    context "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end

      it "returns successfully" do
        get :name_search, {:term => 'MyString'}, valid_session
        expect(response).to be_success
      end

      it "returns 2 items" do
        get :name_search, {:term => 'MyString'}, valid_session
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end

  end


end
