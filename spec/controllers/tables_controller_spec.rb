require 'rails_helper'

RSpec.describe TablesController, :type => :controller do
  before { session[:user_id] = current_user_id }

  let(:current_user_id)  { User.create(user_attributes).id }
  let(:valid_attributes) { FactoryGirl.attributes_for(:table, current_user_id: current_user_id) }
  let(:user_attributes)  { FactoryGirl.attributes_for(:user) }
  let(:valid_session)    { {} }

  describe "GET index" do
    let(:table) { Table.create(valid_attributes) }

    it "assigns all tables as @tables" do
      get :index, {}, valid_session
      expect(assigns(:tables)).to eq([table])
    end
  end

  describe "GET search" do
    before do
      @table1 = FactoryGirl.create(:table, logic_table_name: "name01", current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
      @table2 = FactoryGirl.create(:table, logic_table_name: "name02", current_user_id: current_user_id, status: Constants::STATUS[:SALA2])
      @table3 = FactoryGirl.create(:table, logic_table_name: "name3",  current_user_id: current_user_id, status: Constants::STATUS[:PRODUCAO])
      @table4 = FactoryGirl.create(:table, logic_table_name: "name4",  current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
    end

    context "with invalid params" do
      context "when no params is sent" do
        it 'returns all records' do
          post :search, valid_session
          expect(assigns(:tables)).to eq([@table1, @table2, @table3, @table4])
          expect(response).to render_template("index")
        end
      end

      context "when params is blank" do
        it 'returns all records' do
          post :search, { table_name: "", status: "" }, valid_session
          expect(assigns(:tables)).to eq([@table1, @table2, @table3, @table4])
          expect(response).to render_template("index")
        end
      end
    end

    context "with valid params" do
      subject { post :search, { text_param: name, status_param: status }, valid_session }

      context "with only text param" do
        context "with no existent name" do
          let(:name)   { "invalid" }
          let(:status) { "" }

          it 'returns no records' do
            subject
            expect(assigns(:tables)).to eq([])
          end
        end

        context "with part of existent name" do
          let(:name)   { 'name0' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:tables)).to eq([@table1, @table2])
          end
        end

        context "with exactly the same name" do
          let(:name)   { 'name3' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:tables)).to eq([@table3])
          end
        end
      end

      context "with only status param" do
        let(:name)   { '' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:tables)).to eq([@table1, @table4])
        end
      end

      context "with both params" do
        let(:name)   { 'name0' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:tables)).to eq([@table1])
          expect(response).to render_template("index")
        end
      end
    end
  end
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
        FactoryGirl.create(:variable, id: 1, current_user_id: current_user_id)
        FactoryGirl.create(:variable, id: 2, current_user_id: current_user_id)
      end

      it "creates a new Table" do
        expect {
          post :create, {:table => valid_attributes, variable_ids: ["1", "2"]}, valid_session
        }.to change(Table, :count).by(1)
      end

      it "assigns a newly created table as @table" do
        post :create, {:table => valid_attributes, variable_ids: ["1", "2"]}, valid_session
        expect(assigns(:table)).to be_a(Table)
        expect(assigns(:table)).to be_persisted
        expect(assigns(:table).status).to eq 'sala1'
      end

      it "redirects to the created table" do
        post :create, {:table => valid_attributes, variable_ids: ["1", "2"]}, valid_session
        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela criada com sucesso'}))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1, current_user_id: current_user_id)
        FactoryGirl.create(:variable, id: 2, current_user_id: current_user_id)
      end

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
        table = Table.create! valid_attributes.merge( variable_ids: ["1", "2"] )
        put :update, {:id           => table.to_param,
                      :table        => new_attributes,
                      variable_ids: "|,1,2"
        }, valid_session
        #put :update, {:id => table.to_param, :table => new_attributes}, valid_session
      end

      it "assigns the requested table as @table" do
        table = Table.create! valid_attributes.merge( variable_ids: ["1", "2"] )

        put :update, {
          :id => table.to_param,
          :table => valid_attributes,
          variable_ids: "|,1,2"
        }, valid_session
        expect(assigns(:table)).to eq(table)
      end

      it "assigns the requested table as @table and changes status" do
        table = Table.create! valid_attributes.merge( variable_ids: ["1", "2"] )
        put :update, { id: table.to_param,
                       table: valid_attributes,
                       update_status: "sala2",
                       variable_ids: "|,1,2"
        }, valid_session
        expect(assigns(:table)).to eq(table)
        expect(assigns(:table).status).to eq 'sala2'
      end

      it "redirects to the table" do
        table = Table.create! valid_attributes.merge( variable_ids: ["1", "2"] )
        put :update, {
          :id => table.to_param,
          :table => valid_attributes,
          variable_ids: "|,1,2"
        }, valid_session
        expect(response).to redirect_to(root_path({status: 'table', notice: 'Tabela atualizada com sucesso'}))
      end
    end
  end

  describe "GET variables search" do
    describe "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end
      it "returns successfully" do
        table = Table.create!(
          valid_attributes.merge( variable_ids: ["1", "2"] )
        )
        get :variables_search, {:id => table.to_param}, valid_session
        expect(response).to be_success
      end
      it "returns 2 items" do
        table = Table.create!(
          valid_attributes.merge( variable_ids: ["1", "2"] )
        )
        get :variables_search, {:id => table.to_param}, valid_session
        expect(JSON.parse(response.body).length).to eq(2)
      end
    end
    describe "with invalid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end
      describe "without params" do
        it "returns successfully" do
          get :variables_search, valid_session
          expect(response).to be_success
        end
        it "returns 2 items" do
          get :variables_search, valid_session
          expect(JSON.parse(response.body).length).to eq(2)
        end
      end
    end

  end


end
