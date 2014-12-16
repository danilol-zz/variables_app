require 'rails_helper'

describe Variable do

  describe "attributes validations" do
    it { should respond_to :name }
    it { should respond_to :sas_variable_def }
    it { should respond_to :sas_variable_domain }
    it { should respond_to :created_in_sprint }
    it { should respond_to :updated_in_sprint }
    it { should respond_to :sas_data_model_status }
    it { should respond_to :drs_bi_diagram_name }
    it { should respond_to :drs_variable_status }
    it { should respond_to :room_1_notes }
    it { should respond_to :width }
    it { should respond_to :decimal }
    it { should respond_to :default_value }
    it { should respond_to :room_2_notes }
    it { should respond_to :model_field_name }
    it { should respond_to :data_type }
    it { should respond_to :sas_variable_rule_def }
    it { should respond_to :sas_update_periodicity }
    it { should respond_to :domain_type }
    it { should respond_to :key }
    it { should respond_to :variable_type }
    it { should respond_to :owner }
    it { should respond_to :status }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }

    context "statuses" do
      before do
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:variable, status: Constants::STATUS[:EFETIVO])
        FactoryGirl.create(:variable, status: Constants::STATUS[:EFETIVO])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
      end

      it "check the scopes" do
        expect(Variable.draft.count).to eq 3
        expect(Variable.development.count).to eq 4
        expect(Variable.done.count).to eq 2
      end
    end
  end

  context "campaigns_x_variables" do
    before do
      c1 = FactoryGirl.create(:campaign, name: "c1")
      c2 = FactoryGirl.create(:campaign, name: "c2")
      c3 = FactoryGirl.create(:campaign, name: "c3")
      @variable = FactoryGirl.create(:variable)
      @variable.campaigns << [c1, c2, c3]
    end

    it "should have relationship" do
      expect(@variable.campaigns.count).to eq 3
      expect(@variable.campaigns.map(&:name)).to include "c1", "c2", "c3"
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:variable)
      @b = FactoryGirl.create(:variable)
      @c = FactoryGirl.create(:variable, id: 10)
      @d = FactoryGirl.create(:variable, id: 100)
      @e = FactoryGirl.create(:variable, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "VA001"
      expect(@b.code).to eq "VA002"
      expect(@c.code).to eq "VA010"
      expect(@d.code).to eq "VA100"
      expect(@e.code).to eq "VA1000"
    end
  end
end
