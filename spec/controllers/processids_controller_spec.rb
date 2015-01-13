require 'rails_helper'

RSpec.describe ProcessidsController, :type => :controller do
  before { session[:user_id] = current_user_id }

  let(:current_user_id)  { User.create(user_attributes).id }
  let(:valid_attributes) { FactoryGirl.attributes_for(:processid, current_user_id: current_user_id) }
  let(:user_attributes)  { FactoryGirl.attributes_for(:user) }
  let(:valid_session)    { {} }

  describe "GET index" do
    let(:processid) { Processid.create(valid_attributes) }

    it "assigns all processid as @processids" do
      get :index, {}, valid_session
      expect(assigns(:processids)).to eq([processid])
    end
  end

  describe "GET search" do
    before do
      @processid1 = FactoryGirl.create(:processid, process_number:   33, current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
      @processid2 = FactoryGirl.create(:processid, process_number:   44, current_user_id: current_user_id, status: Constants::STATUS[:SALA2])
      @processid3 = FactoryGirl.create(:processid, process_number:   53, current_user_id: current_user_id, status: Constants::STATUS[:PRODUCAO])
      @processid4 = FactoryGirl.create(:processid, process_number: 1098, current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
    end

    context "with invalid params" do
      context "when no params is sent" do
        it 'returns all records' do
          post :search, valid_session
          expect(assigns(:processids)).to eq([@processid1, @processid2, @processid3, @processid4])
          expect(response).to render_template("index")
        end
      end

      context "when params is blank" do
        it 'returns all records' do
          post :search, { text_param: "", status_param: "" }, valid_session
          expect(assigns(:processids)).to eq([@processid1, @processid2, @processid3, @processid4])
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
            expect(assigns(:processids)).to eq([])
          end
        end

        context "with part of existent name" do
          let(:file)   { '3' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:processids)).to eq([@processid1, @processid3])
          end
        end

        context "with exactly the same name" do
          let(:file)   { '53' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:processids)).to eq([@processid3])
          end
        end
      end

      context "with only status param" do
        let(:file)   { '' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:processids)).to eq([@processid1, @processid4])
        end
      end

      context "with both params" do
        let(:file)   { '1098' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:processids)).to eq([@processid4])
          expect(response).to render_template("index")
        end
      end
    end
  end

  describe "GET new" do
    it "assigns a new processid as @processid" do
      get :new, {}, valid_session

      expect(assigns(:processid)).to be_a_new(Processid)
    end
  end

  describe "GET edit" do
    it "assigns the requested processid as @processid" do
      processid = Processid.create! valid_attributes

      get :edit, {:id => processid.to_param}, valid_session

      expect(assigns(:processid)).to eq(processid)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end

      it "creates a new Processid" do
        expect {
          post :create, {:processid => valid_attributes}, valid_session
        }.to change(Processid, :count).by(1)
      end

      it "assigns a newly created processid as @processid" do
        post :create, {:processid => valid_attributes}, valid_session

        expect(assigns(:processid)).to be_a(Processid)
        expect(assigns(:processid)).to be_persisted
        expect(assigns(:processid).status).to eq 'sala2'
      end

      it "redirects to the created processid" do
        post :create, {:processid => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'processid', notice: 'Processo criado com sucesso'}))
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        new_attributes = {
          :process_number => 'teste',
          :mnemonic => 'teste',
          :routine_name => 'teste',
          :var_table_name => 'teste' ,
          :conference_rule => 'teste',
          :acceptance_percent => 'teste',
          :keep_previous_work => 'teste',
          :counting_rule => 'teste',
          :notes => 'teste'
        }
      }

      it "updates the requested processid" do
        processid = Processid.create! valid_attributes

        put :update, {:id => processid.to_param, :processid => new_attributes}, valid_session

        processid.reload
      end

      it "assigns the requested processid as @processid" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        processid = Processid.create! valid_attributes

        put :update, {:id => processid.to_param, :processid => valid_attributes}, valid_session

        expect(assigns(:processid)).to eq(processid)
      end

      it "assigns the requested processid as @processid and changes status" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        processid = Processid.create! valid_attributes

        put :update, { id: processid.to_param, processid: valid_attributes, update_status: "producao" }, valid_session

        expect(assigns(:processid)).to eq(processid)
        expect(assigns(:processid).status).to eq 'producao'
      end

      it "redirects to the processid" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        processid = Processid.create! valid_attributes

        put :update, {:id => processid.to_param, :processid => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'processid', notice: 'Processo atualizado com sucesso'}))
      end
    end
  end
end
