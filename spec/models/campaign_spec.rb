require 'rails_helper'

describe Campaign do

  it { should respond_to :ident }
  it { should respond_to :name }
  it { should respond_to :priority }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :campaign_origin }
  it { should respond_to :channel }
  it { should respond_to :communication_channel }
  it { should respond_to :product }
  it { should respond_to :description }
  it { should respond_to :criterion }
  it { should respond_to :exists_in_legacy }
  it { should respond_to :automatic_routine }
  it { should respond_to :factory_criterion_status }
  it { should respond_to :prioritized_variables_qty }
  it { should respond_to :complied_variables_qty }
  it { should respond_to :process_type }
  it { should respond_to :crm_room_suggestion }
  it { should respond_to :it_status }
  it { should respond_to :notes }

  context "statuses" do
    before do
      FactoryGirl.create(:campaign, status: "Rascunho")
      FactoryGirl.create(:campaign, status: "Rascunho")
      FactoryGirl.create(:campaign, status: "Finalizado")
      FactoryGirl.create(:campaign, status: "Finalizado")
      FactoryGirl.create(:campaign, status: "Desenvolvimento")
      FactoryGirl.create(:campaign, status: "Desenvolvimento")
      FactoryGirl.create(:campaign, status: "Desenvolvimento")
      FactoryGirl.create(:campaign, status: "Desenvolvimento")
      FactoryGirl.create(:campaign, status: "Rascunho")
    end

    it "check the scopes" do
      expect(Campaign.draft.count).to eq 3
      expect(Campaign.development.count).to eq 4
      expect(Campaign.done.count).to eq 2
    end
  end
end
