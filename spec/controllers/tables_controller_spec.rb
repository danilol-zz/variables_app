require 'rails_helper'

RSpec.describe TablesController, :type => :controller do
  before do
    session[:user_id] = User.create(user_attributes)
  end

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
      :variable_list => {"1" => "checked", "2" => "checked" },
      :current_user_id => session[:user_id].id
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

  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new table as @table" do
      get :new, {}, valid_session

      expect(assigns(:table)).to be_a_new(Table)
    end
  end

  describe "GET edit" do
    it "assigns the requested table as @table" do
      table = Table.create! valid_attributes

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
          post :create, {:table => valid_attributes}, valid_session
        }.to change(Table, :count).by(1)
      end

      it "assigns a newly created table as @table" do
        post :create, {:table => valid_attributes}, valid_session

        expect(assigns(:table)).to be_a(Table)
        expect(assigns(:table)).to be_persisted
        expect(assigns(:table).status).to eq 'sala1'
      end

      it "redirects to the created table" do
        post :create, {:table => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela criada com sucesso'}))
      end
    end
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

        put :update, {:id => table.to_param, :table => new_attributes}, valid_session
      end

      it "assigns the requested table as @table" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        table = Table.create! valid_attributes

        put :update, {:id => table.to_param, :table => valid_attributes}, valid_session

        expect(assigns(:table)).to eq(table)
      end

      it "assigns the requested table as @table and changes status" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)


        table = Table.create! valid_attributes

        put :update, { id: table.to_param, table: valid_attributes, update_status: "sala2" }, valid_session

        expect(assigns(:table)).to eq(table)
        expect(assigns(:table).status).to eq 'sala2'
      end

      it "redirects to the table" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        table = Table.create! valid_attributes

        put :update, {:id => table.to_param, :table => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela atualizada com sucesso'}))
      end
    end
  end
end
