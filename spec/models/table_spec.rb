require 'rails_helper'

describe Table do

  it { should respond_to :logic_table_name }
  it { should respond_to :type }
  it { should respond_to :name }
  it { should respond_to :key }
  it { should respond_to :initial_volume }
  it { should respond_to :growth_estimation }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :room_1_notes }
  it { should respond_to :final_physical_table_name }
  it { should respond_to :mirror_physical_table_name }
  it { should respond_to :final_table_number }
  it { should respond_to :mirror_table_number }
  it { should respond_to :mnemonic }
  it { should respond_to :routine_number }
  it { should respond_to :master_base }
  it { should respond_to :hive_table }
  it { should respond_to :big_data_routine_name }
  it { should respond_to :output_routine_name }
  it { should respond_to :ziptrans_routine_name }
  it { should respond_to :mirror_data_stage_routine_name }
  it { should respond_to :final_data_stage_routine_name }
  it { should respond_to :room_2_notes }
  it { should respond_to :key_fields_hive_script }
  it { should respond_to :status }  
  it { should respond_to :created_at }
  it { should respond_to :updated_at }


  context "statuses" do
    before do
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:table, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:table, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:table, status: Constants::STATUS[:SALA1])
    end

    it "check the scopes" do
      expect(Table.draft.count).to eq 3
      expect(Table.development.count).to eq 4
      expect(Table.done.count).to eq 2
    end
  end  

  context ".code" do
    before do
      @a = FactoryGirl.create(:table)
      @b = FactoryGirl.create(:table)
      @c = FactoryGirl.create(:table, id: 10)
      @d = FactoryGirl.create(:table, id: 100)
      @e = FactoryGirl.create(:table, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "TA001"
      expect(@b.code).to eq "TA002"
      expect(@c.code).to eq "TA010"
      expect(@d.code).to eq "TA100"
      expect(@e.code).to eq "TA1000"
    end
  end
end

