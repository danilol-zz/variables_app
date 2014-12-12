require 'rails_helper'

describe Processid do

  it { should respond_to :process_number }
  it { should respond_to :mnemonic }
  it { should respond_to :routine_name }
  it { should respond_to :var_table_name }
  it { should respond_to :conference_rule }
  it { should respond_to :acceptance_percent }
  it { should respond_to :keep_previous_work }
  it { should respond_to :counting_rule }
  it { should respond_to :notes }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }


  context "statuses" do
    before do
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:processid, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:processid, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1])
    end

    it "check the scopes" do
      expect(Processid.draft.count).to eq 3
      expect(Processid.development.count).to eq 4
      expect(Processid.done.count).to eq 2
    end
  end  


  context ".code" do
    before do
      @a = FactoryGirl.create(:processid)
      @b = FactoryGirl.create(:processid)
      @c = FactoryGirl.create(:processid, id: 10)
      @d = FactoryGirl.create(:processid, id: 100)
      @e = FactoryGirl.create(:processid, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "PR001"
      expect(@b.code).to eq "PR002"
      expect(@c.code).to eq "PR010"
      expect(@d.code).to eq "PR100"
      expect(@e.code).to eq "PR1000"
    end
  end
end

