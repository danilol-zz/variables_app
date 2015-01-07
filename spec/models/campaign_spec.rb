require 'rails_helper'

describe Campaign do
  let(:current_user_id) { FactoryGirl.create(:user, profile: profile).id }
  let(:profile) { 'sala1' }

  context "attributes validations" do
    subject { FactoryGirl.build(:campaign, current_user_id: current_user_id)  }

    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to ensure_length_of(:name).is_at_most(50) }
    it { expect(subject).to validate_presence_of(:priority) }
    it { expect(subject).to validate_presence_of(:campaign_origin) }
    it { expect(subject).to ensure_length_of(:campaign_origin).is_at_most(50) }
    it { expect(subject).to validate_presence_of(:created_in_sprint) }
    it { expect(subject).to validate_presence_of(:updated_in_sprint) }
    it { expect(subject).to validate_presence_of(:channel) }
    it { expect(subject).to ensure_length_of(:channel).is_at_most(50) }
    it { expect(subject).to validate_presence_of(:communication_channel) }
    it { expect(subject).to ensure_length_of(:communication_channel).is_at_most(50) }
    it { expect(subject).to validate_presence_of(:product) }
    it { expect(subject).to ensure_length_of(:product).is_at_most(50) }
    it { expect(subject).to validate_presence_of(:description) }
    it { expect(subject).to ensure_length_of(:description).is_at_most(200) }
    it { expect(subject).to validate_presence_of(:criterion) }
    it { expect(subject).to ensure_length_of(:criterion).is_at_most(500) }
    it { expect(subject).to validate_inclusion_of(:factory_criterion_status).in_array(Constants::FactoryCriterionStatus) }
    it { expect(subject).to validate_presence_of(:it_status) }

    context 'when exists in legacy is true' do
      subject(:campaign) { FactoryGirl.build(:campaign, exists_in_legacy: true, current_user_id: current_user_id) }

      it { expect(campaign).to validate_presence_of(:automatic_routine) }
      it { expect(campaign).to ensure_length_of(:automatic_routine).is_at_most(50) }
    end

    context 'when exists in legacy is false' do
      subject(:campaign) { FactoryGirl.build(:campaign, exists_in_legacy: false, current_user_id: current_user_id) }

      it { expect(campaign).to_not validate_presence_of(:automatic_routine) }
      it { expect(campaign).to_not ensure_length_of(:automatic_routine).is_at_most(50) }
    end
  end

  context "scopes" do
    before do
      @campaign1 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 2.hour, current_user_id: current_user_id)
      @campaign2 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 8.hour, current_user_id: current_user_id)
      @campaign3 = FactoryGirl.create(:campaign, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 7.hour, current_user_id: current_user_id)
      @campaign4 = FactoryGirl.create(:campaign, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 6.hour, current_user_id: current_user_id)
      @campaign5 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 5.hour, current_user_id: current_user_id)
      @campaign6 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 4.hour, current_user_id: current_user_id)
      @campaign7 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 3.hour, current_user_id: current_user_id)
      @campaign8 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 2.days, current_user_id: current_user_id)
      @campaign9 = FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 1.hour, current_user_id: current_user_id)
    end

    context "statuses" do
      it "filters by status" do
        expect(Campaign.draft.count).to eq 3
        expect(Campaign.development.count).to eq 4
        expect(Campaign.done.count).to eq 2
      end
    end

    context "recent" do
      it "orders the records by most recent changes" do
        expect(Campaign.recent.limit(3)).to eq [@campaign9, @campaign1, @campaign7]
      end
    end
  end

  context "campaigns_x_variables" do
    before do
      var1 = FactoryGirl.create(:variable, name: "var1")
      var2 = FactoryGirl.create(:variable, name: "var2")
      var3 = FactoryGirl.create(:variable, name: "var3")
      @campaign = FactoryGirl.create(:campaign, current_user_id: current_user_id)
      @campaign.variables << [var1, var2, var3]
    end

    it "has relationship" do
      expect(@campaign.variables.count).to eq 3
      expect(@campaign.variables.map(&:name)).to include "var1", "var2", "var3"
    end
  end

  context ".set_variables" do
    context "on create" do
      subject { FactoryGirl.create(:campaign, current_user_id: current_user_id) }

      context "with no variables selected" do
        it "not saves variable" do
          subject.set_variables(nil)

          expect(subject.variables.size).to eq 0
        end
      end

      context "with variables selected" do
        before do
          @campaign = FactoryGirl.build(:campaign, current_user_id: current_user_id)

          FactoryGirl.create(:variable, id: 1, name: "v1")
          FactoryGirl.create(:variable, id: 5, name: "v2")
          FactoryGirl.create(:variable, id: 9, name: "v3")
        end

        context "with one variable selected" do
          let(:campaign_params) { {"5"=>"checked" } }

          it "saves cmpaigns" do
            subject.set_variables(campaign_params)
            expect(subject.variables.size).to eq 1
          end
        end

        context "with many variables selected" do
          let(:campaign_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves variables" do
            subject.set_variables(campaign_params)
            expect(subject.variables.size).to eq 3
          end
        end
      end
    end

    context "on update" do
      before do
        v1 = FactoryGirl.create(:variable, id:  1, name: "v1")
        v2 = FactoryGirl.create(:variable, id:  5, name: "v2")
        v3 = FactoryGirl.create(:variable, id:  9, name: "v3")
        v4 = FactoryGirl.create(:variable, id: 15, name: "v4")
        v5 = FactoryGirl.create(:variable, id: 19, name: "v5")
        @campaign = FactoryGirl.create(:campaign, variables: [v1, v2], current_user_id: current_user_id)
      end

      context "with no variables selected" do
        it "unsets saved variables" do
          @campaign.set_variables
          @campaign.save
          expect(@campaign.variables.count).to eq 0
        end
      end

      context "with variables selected" do
        context "with one variable selected" do
          let(:campaign_params) { {"5"=>"checked" } }

          it "saves only last selected variable" do
            @campaign.set_variables(campaign_params)
            @campaign.save
            expect(@campaign.variables.count).to eq 1
          end
        end

        context "with many variables selected" do
          let(:campaign_params) { {"15"=>"checked", "19" => "checked", "9" => "checked"} }

          it "saves variables" do
            @campaign.set_variables(campaign_params)
            @campaign.save
            expect(@campaign.variables.count).to eq 3
          end
        end
      end
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:campaign, id: 1,    current_user_id: current_user_id)
      @b = FactoryGirl.create(:campaign, id: 87,   current_user_id: current_user_id)
      @c = FactoryGirl.create(:campaign, id: 10,   current_user_id: current_user_id)
      @d = FactoryGirl.create(:campaign, id: 100,  current_user_id: current_user_id)
      @e = FactoryGirl.create(:campaign, id: 1000, current_user_id: current_user_id)
    end

    it "generates the codes successfully" do
      expect(@a.code).to eq "CA001"
      expect(@b.code).to eq "CA087"
      expect(@c.code).to eq "CA010"
      expect(@d.code).to eq "CA100"
      expect(@e.code).to eq "CA1000"
    end
  end

  context ".status_screen_name" do
    subject { FactoryGirl.build(:campaign, name: name, current_user_id: current_user_id) }

    context "when name is nil"  do
      let(:name) { nil }

      it "returns an empty string" do
        expect(subject.status_screen_name).to be_blank
      end
    end

    context "when name has value" do
      context "when name has less than 20 characters" do
        let(:name) { "testnamestring" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestring"
        end
      end

      context "when name has more than 20 characters" do
        let(:name) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestringbigger"
        end
      end
    end
  end
end
