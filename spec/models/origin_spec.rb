require 'rails_helper'

describe Origin do

  it { should respond_to :file_name }
  it { should respond_to :file_description }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :abbreviation }
  it { should respond_to :base_type }
  it { should respond_to :book_mainframe }
  it { should respond_to :periodicity }
  it { should respond_to :periodicity_details }
  it { should respond_to :data_retention_type }
  it { should respond_to :extractor_file_type }
  it { should respond_to :room_1_notes }
  it { should respond_to :mnemonic }
  it { should respond_to :cd5_portal_origin_code }
  it { should respond_to :cd5_portal_origin_name }
  it { should respond_to :cd5_portal_destination_code }
  it { should respond_to :cd5_portal_destination_name }
  it { should respond_to :hive_table_name }
  it { should respond_to :mainframe_storage_type }
  it { should respond_to :room_2_notes }
  it { should respond_to :dmt_advice }
  it { should respond_to :dmt_classification }
  it { should respond_to :status }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }

  context ".code" do
    before do
      @a = FactoryGirl.create(:origin)
      @b = FactoryGirl.create(:origin)
      @c = FactoryGirl.create(:origin, id: 10)
      @d = FactoryGirl.create(:origin, id: 100)
      @e = FactoryGirl.create(:origin, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "OR001"
      expect(@b.code).to eq "OR002"
      expect(@c.code).to eq "OR010"
      expect(@d.code).to eq "OR100"
      expect(@e.code).to eq "OR1000"
    end
  end

  context "statuses" do
    before do
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:origin, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:origin, status: Constants::STATUS[:EFETIVO])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2])
      FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1])
    end

    it "check the scopes" do
      expect(Origin.draft.count).to       eq 3
      expect(Origin.development.count).to eq 4
      expect(Origin.done.count).to        eq 2
    end
  end
end
