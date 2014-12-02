require 'rails_helper'

RSpec.describe ProcessidsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Processid. As you add validations to Processid, be sure to
  # adjust the attributes here as well.
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
      :notes => 'teste'
    }
  }

  let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProcessidsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all processids as @processids" do
      processid = Processid.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:processids)).to eq([processid])
    end
  end

  describe "GET show" do
    it "assigns the requested processid as @processid" do
      processid = Processid.create! valid_attributes
      get :show, {:id => processid.to_param}, valid_session
      expect(assigns(:processid)).to eq(processid)
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
      it "creates a new Processid" do
        expect {
          post :create, {:processid => valid_attributes}, valid_session
        }.to change(Processid, :count).by(1)
      end

      it "assigns a newly created processid as @processid" do
        post :create, {:processid => valid_attributes}, valid_session
        expect(assigns(:processid)).to be_a(Processid)
        expect(assigns(:processid)).to be_persisted
      end

      it "redirects to the created processid" do
        post :create, {:processid => valid_attributes}, valid_session
        expect(response).to redirect_to(Processid.last)
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved processid as @processid" do
    #    post :create, {:processid => invalid_attributes}, valid_session
    #    expect(assigns(:processid)).to be_a_new(Processid)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:processid => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
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
        #skip("Add assertions for updated state")
      end

      it "assigns the requested processid as @processid" do
        processid = Processid.create! valid_attributes
        put :update, {:id => processid.to_param, :processid => valid_attributes}, valid_session
        expect(assigns(:processid)).to eq(processid)
      end

      it "redirects to the processid" do
        processid = Processid.create! valid_attributes
        put :update, {:id => processid.to_param, :processid => valid_attributes}, valid_session
        expect(response).to redirect_to(processid)
      end
    end

    #describe "with invalid params" do
    #  it "assigns the processid as @processid" do
    #    processid = Processid.create! valid_attributes
    #    put :update, {:id => processid.to_param, :processid => invalid_attributes}, valid_session
    #    expect(assigns(:processid)).to eq(processid)
    #  end

    #  it "re-renders the 'edit' template" do
    #    processid = Processid.create! valid_attributes
    #    put :update, {:id => processid.to_param, :processid => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
  end

  describe "DELETE destroy" do
    it "destroys the requested processid" do
      processid = Processid.create! valid_attributes
      expect {
        delete :destroy, {:id => processid.to_param}, valid_session
      }.to change(Processid, :count).by(-1)
    end

    it "redirects to the processids list" do
      processid = Processid.create! valid_attributes
      delete :destroy, {:id => processid.to_param}, valid_session
      expect(response).to redirect_to(processids_url)
    end
  end

end
