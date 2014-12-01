require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Campaign. As you add validations to Campaign, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {

    valid_attributes = {
      :ident => 'teste',
      :name => 'teste',
      :priority => 'teste',
      :created_in_sprint => 'teste',
      :updated_in_sprint => 'teste',
      :campaign_origin => 'teste',
      :channel => 'teste',
      :communication_channel => 'teste',
      :product => 'teste',
      :description => 'teste',
      :criterion => 'teste',
      :exists_in_legacy => 'teste',
      :automatic_routine => 'teste',
      :factory_criterion_status => 'teste',
      :prioritized_variables_qty => 'teste',
      :complied_variables_qty => 'teste',
      :process_type => 'teste',
      :crm_room_suggestion => 'teste',
      :it_status => 'teste',
      :notes => 'teste'
    }
  }

  let(:invalid_attributes) {
    #skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CampaignsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all campaigns as @campaigns" do
      campaign = Campaign.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:campaigns)).to eq([campaign])
    end
  end

  describe "GET show" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :show, {:id => campaign.to_param}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      get :new, {}, valid_session
      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "GET edit" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create! valid_attributes
      get :edit, {:id => campaign.to_param}, valid_session
      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Campaign" do
        expect {
          post :create, {:campaign => valid_attributes}, valid_session
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        post :create, {:campaign => valid_attributes}, valid_session
        expect(assigns(:campaign)).to be_a(Campaign)
        expect(assigns(:campaign)).to be_persisted
      end

      it "redirects to the created campaign" do
        post :create, {:campaign => valid_attributes}, valid_session
        expect(response).to redirect_to(Campaign.last)
      end
    end

    #describe "with invalid params" do
    #  it "assigns a newly created but unsaved campaign as @campaign" do
    #    post :create, {:campaign => invalid_attributes}, valid_session
    #    expect(assigns(:campaign)).to be_a_new(Campaign)
    #  end

    #  it "re-renders the 'new' template" do
    #    post :create, {:campaign => invalid_attributes}, valid_session
    #    expect(response).to render_template("new")
    #  end
    #end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {

        new_attributes = {
          :ident => 'teste',
          :name => 'teste',
          :priority => 'teste',
          :created_in_sprint => 'teste',
          :updated_in_sprint => 'teste',
          :campaign_origin => 'teste',
          :channel => 'teste',
          :communication_channel => 'teste',
          :product => 'teste',
          :description => 'teste',
          :criterion => 'teste',
          :exists_in_legacy => 'teste',
          :automatic_routine => 'teste',
          :factory_criterion_status => 'teste',
          :prioritized_campaigns_qty => 'teste',
          :complied_campaigns_qty => 'teste',
          :process_type => 'teste',
          :crm_room_suggestion => 'teste',
          :it_status => 'teste',
          :notes => 'teste'
        }

      }

      it "updates the requested campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {:id => campaign.to_param, :campaign => new_attributes}, valid_session
        campaign.reload
        #skip("Add assertions for updated state")
      end

      it "assigns the requested campaign as @campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {:id => campaign.to_param, :campaign => valid_attributes}, valid_session
        expect(assigns(:campaign)).to eq(campaign)
      end

      it "redirects to the campaign" do
        campaign = Campaign.create! valid_attributes
        put :update, {:id => campaign.to_param, :campaign => valid_attributes}, valid_session
        expect(response).to redirect_to(campaign)
      end
    end

    #describe "with invalid params" do
    #  it "assigns the campaign as @campaign" do
    #    campaign = Campaign.create! valid_attributes
    #    put :update, {:id => campaign.to_param, :campaign => invalid_attributes}, valid_session
    #    expect(assigns(:campaign)).to eq(campaign)
    #  end

    #  it "re-renders the 'edit' template" do
    #    campaign = Campaign.create! valid_attributes
    #    put :update, {:id => campaign.to_param, :campaign => invalid_attributes}, valid_session
    #    expect(response).to render_template("edit")
    #  end
    #end
  end

  describe "DELETE destroy" do
    it "destroys the requested campaign" do
      campaign = Campaign.create! valid_attributes
      expect {
        delete :destroy, {:id => campaign.to_param}, valid_session
      }.to change(Campaign, :count).by(-1)
    end

    it "redirects to the campaigns list" do
      campaign = Campaign.create! valid_attributes
      delete :destroy, {:id => campaign.to_param}, valid_session
      expect(response).to redirect_to(campaigns_url)
    end
  end

end