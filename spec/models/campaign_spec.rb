require 'rails_helper'

describe Campaign do
  context "attributes validations" do
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
    it { should respond_to :owner }
    it { should respond_to :status }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }

    context "statuses" do
      before do
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:EFETIVO])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:EFETIVO])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1])
      end

      it "should check the scopes" do
        expect(Campaign.draft.count).to eq 3
        expect(Campaign.development.count).to eq 4
        expect(Campaign.done.count).to eq 2
      end
    end
  end

  context "campaigns_x_variables" do
    before do
      var1 = FactoryGirl.create(:variable, name: "var1")
      var2 = FactoryGirl.create(:variable, name: "var2")
      var3 = FactoryGirl.create(:variable, name: "var3")
      @campaign = FactoryGirl.create(:campaign)
      @campaign.variables << [var1, var2, var3]
    end

    it "should have relationship" do
      expect(@campaign.variables.count).to eq 3
      expect(@campaign.variables.map(&:name)).to include "var1", "var2", "var3"
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:campaign)
      @b = FactoryGirl.create(:campaign)
      @c = FactoryGirl.create(:campaign, id: 10)
      @d = FactoryGirl.create(:campaign, id: 100)
      @e = FactoryGirl.create(:campaign, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "CA001"
      expect(@b.code).to eq "CA002"
      expect(@c.code).to eq "CA010"
      expect(@d.code).to eq "CA100"
      expect(@e.code).to eq "CA1000"
    end
  end
end
