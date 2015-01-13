require 'rails_helper'

RSpec.describe CampaignsController, :type => :controller do
  before { session[:user_id] = current_user_id }

  let(:current_user_id)  { User.create(user_attributes).id }
  let(:valid_attributes) { FactoryGirl.attributes_for(:campaign, current_user_id: current_user_id) }
  let(:user_attributes)  { FactoryGirl.attributes_for(:user) }
  let(:valid_session)    { {} }

  describe "GET new" do
    it "assigns a new campaign as @campaign" do
      get :new, {}, valid_session

      expect(assigns(:campaign)).to be_a_new(Campaign)
    end
  end

  describe "GET index" do
    let(:campaign) { Campaign.create(valid_attributes) }

    it "assigns all campaigns as @campaigns" do
      get :index, {}, valid_session
      expect(assigns(:campaigns)).to eq([campaign])
    end
  end

  describe "GET search" do
    before do
      @campaign1 = FactoryGirl.create(:campaign, name: "name01", current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
      @campaign2 = FactoryGirl.create(:campaign, name: "name02", current_user_id: current_user_id, status: Constants::STATUS[:SALA2])
      @campaign3 = FactoryGirl.create(:campaign, name: "name3",  current_user_id: current_user_id, status: Constants::STATUS[:PRODUCAO])
      @campaign4 = FactoryGirl.create(:campaign, name: "name4",  current_user_id: current_user_id, status: Constants::STATUS[:SALA1])
    end

    context "with invalid params" do
      context "when no params is sent" do
        it 'returns all records' do
          post :search, valid_session
          expect(assigns(:campaigns)).to eq([@campaign1, @campaign2, @campaign3, @campaign4])
          expect(response).to render_template("index")
        end
      end

      context "when params is blank" do
        it 'returns all records' do
          post :search, { text_param: "", status_param: "" }, valid_session
          expect(assigns(:campaigns)).to eq([@campaign1, @campaign2, @campaign3, @campaign4])
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
            expect(assigns(:campaigns)).to eq([])
          end
        end

        context "with part of existent name" do
          let(:name)   { 'name0' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:campaigns)).to eq([@campaign1, @campaign2])
          end
        end

        context "with exactly the same name" do
          let(:name)   { 'name3' }
          let(:status) { "" }

          it 'returns filtered records' do
            subject
            expect(assigns(:campaigns)).to eq([@campaign3])
          end
        end
      end

      context "with only status param" do
        let(:name)   { '' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:campaigns)).to eq([@campaign1, @campaign4])
        end
      end

      context "with both params" do
        let(:name)   { 'name0' }
        let(:status) { "sala1" }

        it 'returns filtered records' do
          subject
          expect(assigns(:campaigns)).to eq([@campaign1])
          expect(response).to render_template("index")
        end
      end
    end
  end
  describe "GET edit" do
    it "assigns the requested campaign as @campaign" do
      campaign = Campaign.create!(valid_attributes)

      get :edit, {:id => campaign.to_param}, valid_session

      expect(assigns(:campaign)).to eq(campaign)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      before do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)
      end

      it "creates a new Campaign" do
        expect {
          post :create, {:campaign => valid_attributes}, valid_session
        }.to change(Campaign, :count).by(1)
      end

      it "assigns a newly created campaign as @campaign" do
        post :create, {:campaign => valid_attributes}, valid_session

        expect(assigns(:campaign)).to be_a(Campaign)
        expect(assigns(:campaign)).to be_persisted
        expect(assigns(:campaign).status).to eq 'sala1'
      end

      it "redirects to the created campaign" do
        post :create, {:campaign => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'campaign', notice: 'Campanha criada com sucesso'}))
      end
    end
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
          :criterion => 'teste',
          :exists_in_legacy => 'teste',
          :automatic_routine => 'teste',
          :factory_criterion_status => 'teste',
          :process_type => 'teste',
          :crm_room_suggestion => 'teste',
          :it_status => 'teste',
          :notes => 'teste'
        }

      }

      it "updates the requested campaign" do
        campaign = Campaign.create! valid_attributes

        put :update, {:id => campaign.to_param, :campaign => new_attributes}, valid_session
      end

      it "assigns the requested campaign as @campaign" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        campaign = Campaign.create! valid_attributes

        put :update, {:id => campaign.to_param, :campaign => valid_attributes}, valid_session

        expect(assigns(:campaign)).to eq(campaign)
        expect(assigns(:campaign).status).to eq 'sala1'
      end

      it "assigns the requested campaign as @campaign and changes status" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        campaign = Campaign.create valid_attributes

        put :update, { id: campaign.to_param, campaign: valid_attributes, update_status: "sala2" }, valid_session

        expect(assigns(:campaign)).to eq(campaign)
        expect(assigns(:campaign).status).to eq 'sala2'
      end

      it "redirects to the campaign" do
        FactoryGirl.create(:variable, id: 1)
        FactoryGirl.create(:variable, id: 2)

        campaign = Campaign.create! valid_attributes

        put :update, {:id => campaign.to_param, :campaign => valid_attributes}, valid_session

        expect(response).to redirect_to(root_path({status: 'campaign', notice: 'Campanha atualizada com sucesso'}))
      end
    end
  end
end
