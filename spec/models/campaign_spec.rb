require 'rails_helper'

describe Campaign do
  let(:profile) { 'sala1' }

  before do
    user = FactoryGirl.create(:user, profile: profile)

    subject.current_user_id = user.id
  end

  context "attributes validations" do

   it { expect(subject).to validate_presence_of(:name) }
   it { expect(subject).to ensure_length_of(:name).is_at_most(50) }

    context "statuses" do
      before do
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:PRODUCAO])
        FactoryGirl.create(:campaign, status: Constants::STATUS[:PRODUCAO])
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

  context ".set_variables" do
    context "on create" do
      subject { FactoryGirl.create(:campaign) }


      context "with no variables selected" do
        it "not saves variable" do
          subject.set_variables(nil)

          expect(subject.variables.size).to eq 0
        end
      end

      context "with variables selected" do
        before do
          @campaign = FactoryGirl.build(:campaign)

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
        @campaign = FactoryGirl.create(:campaign, variables: [v1, v2])
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

  context ".status_screen_name" do
    subject { FactoryGirl.build(:campaign, name: name) }

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
