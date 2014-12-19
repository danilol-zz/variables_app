require 'rails_helper'

RSpec.describe TablesController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Table. As you add validations to Table, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    valid_attributes = {
      :logic_table_name => 'teste',
      :initial_volume => 'teste',
      :growth_estimation => 'teste',
      :created_in_sprint => 'teste',
      :updated_in_sprint => 'teste',
      :room_1_notes => 'teste',
      :final_physical_table_name => 'teste',
      :mirror_physical_table_name => 'teste',
      :final_table_number => 'teste',
      :mirror_table_number => 'teste',
      :mnemonic => 'teste',
      :routine_number => 'teste',
      :master_base => 'teste',
      :hive_table => 'teste',
      :big_data_routine_name => 'teste',
      :output_routine_name => 'teste',
      :ziptrans_routine_name => 'teste',
      :mirror_data_stage_routine_name => 'teste',
      :final_data_stage_routine_name => 'teste',
      :room_2_notes => 'teste',
      :variable_list => {"1" => "checked", "2" => "checked" }
    }
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

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TablesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new table as @table" do
      session[:user_id] = User.create! user_attributes
      get :new, {}, valid_session
      expect(assigns(:table)).to be_a_new(Table)
    end
  end

  describe "GET edit" do
    it "assigns the requested table as @table" do
      table = Table.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      get :edit, {:id => table.to_param}, valid_session
      expect(assigns(:table)).to eq(table)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end

      it "creates a new Table" do
        expect {
          session[:user_id] = User.create! user_attributes
          post :create, {:table => valid_attributes}, valid_session
        }.to change(Table, :count).by(1)
      end

      it "assigns a newly created table as @table" do
        session[:user_id] = User.create! user_attributes
        post :create, {:table => valid_attributes}, valid_session
        expect(assigns(:table)).to be_a(Table)
        expect(assigns(:table)).to be_persisted
        expect(assigns(:table).status).to eq 'sala1'
      end

      it "redirects to the created table" do
        session[:user_id] = User.create! user_attributes
        post :create, {:table => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela criada com sucesso'}))
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved table as @table" do
    #    post :create, {:table => invalid_attributes}, valid_session
    #    expect(assigns(:table)).to be_a_new(Table)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:table => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :logic_table_name => 'teste',
          :initial_volume => 'teste',
          :growth_estimation => 'teste',
          :created_in_sprint => 'teste',
          :updated_in_sprint => 'teste',
          :room_1_notes => 'teste',
          :final_physical_table_name => 'teste',
          :mirror_physical_table_name => 'teste',
          :final_table_number => 'teste',
          :mirror_table_number => 'teste',
          :mnemonic => 'teste',
          :routine_number => 'teste',
          :master_base => 'teste',
          :hive_table => 'teste',
          :big_data_routine_name => 'teste',
          :output_routine_name => 'teste',
          :ziptrans_routine_name => 'teste',
          :mirror_data_stage_routine_name => 'teste',
          :final_data_stage_routine_name => 'teste',
          :room_2_notes => 'teste'
        }
      }

      it "updates the requested table" do
        table = Table.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => table.to_param, :table => new_attributes}, valid_session
        table.reload
        #skip("Add assertions for updated state")
      end

      it "assigns the requested table as @table" do
        table = Table.create! valid_attributes
        put :update, {:id => table.to_param, :table => valid_attributes}, valid_session
        expect(assigns(:table)).to eq(table)
      end

      it "assigns the requested table as @table and changes status" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
        session[:user_id] = User.create! user_attributes
        table = Table.create! valid_attributes
        put :update, { id: table.to_param, table: valid_attributes, update_status: "sala2" }, valid_session
        expect(assigns(:table)).to eq(table)
        expect(assigns(:table).status).to eq 'sala2'
      end

      it "redirects to the table" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
        table = Table.create! valid_attributes
        session[:user_id] = User.create! user_attributes
        put :update, {:id => table.to_param, :table => valid_attributes}, valid_session
        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela atualizada com sucesso'}))
      end
    end

    #describe "with invalid params" do
    #  it "assigns the table as @table" do
    #    table = Table.create! valid_attributes
    #    put :update, {:id => table.to_param, :table => invalid_attributes}, valid_session
    #    expect(assigns(:table)).to eq(table)
    #  end

    #  it "re-renders the 'edit' template" do
    #    table = Table.create! valid_attributes
    #    put :update, {:id => table.to_param, :table => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
  end

  describe "DELETE destroy" do
    it "destroys the requested table" do
      table = Table.create! valid_attributes
      expect {
        session[:user_id] = User.create! user_attributes
        delete :destroy, {:id => table.to_param}, valid_session
      }.to change(Table, :count).by(-1)
    end

    it "redirects to the tables list" do
      table = Table.create! valid_attributes
      session[:user_id] = User.create! user_attributes
      delete :destroy, {:id => table.to_param}, valid_session
      expect(response).to redirect_to(tables_url)
    end
  end
end
