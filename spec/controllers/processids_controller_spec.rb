require 'rails_helper'

RSpec.describe ProcessidsController, :type => :controller do
  before do
    session[:user_id] = User.create(user_attributes)
  end

  let(:valid_attributes) {
    valid_attributes = {
      :process_number => 'teste',
      :mnemonic => 'teste',
      :routine_name => 'teste',
      :var_table_name => 'teste' ,
      :conference_rule => 'teste',
      :acceptance_percent => 'teste',
      :keep_previous_work => 'teste',
      :counting_rule => 'teste',
      :notes => 'teste',
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
