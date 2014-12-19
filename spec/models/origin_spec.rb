require 'rails_helper'

describe Origin do
  let(:profile) { 'room2' }

  before do
    user = FactoryGirl.create(:user, profile: profile)
    subject.current_user_id = user.id
  end

  context "fields" do
    context "validations" do
      context 'when user profile is room1' do
        let(:profile) { 'sala1' }

        it { expect(subject).to validate_presence_of(:file_name) }
        it { expect(subject).to ensure_length_of(:file_name).is_at_most(50) }
        it { expect(subject).to validate_presence_of(:file_description) }
        it { expect(subject).to ensure_length_of(:file_description).is_at_most(200) }
        it { expect(subject).to validate_presence_of(:created_in_sprint) }
        it { expect(subject).to validate_presence_of(:updated_in_sprint) }
        it { expect(subject).to validate_presence_of(:abbreviation) }
        it { expect(subject).to ensure_length_of(:abbreviation).is_at_most(3) }
        it { expect(subject).to validate_presence_of(:base_type) }
        it { expect(subject).to ensure_length_of(:book_mainframe).is_at_most(10) }
        it { expect(subject).to validate_presence_of(:periodicity) }
        it { expect(subject).to ensure_length_of(:periodicity_details).is_at_most(50) }
        it { expect(subject).to validate_presence_of(:data_retention_type) }
        it { expect(subject).to validate_presence_of(:extractor_file_type) }
        it { expect(subject).to ensure_length_of(:room_1_notes).is_at_most(500) }
        #it { expect(subject).to ensure_length_of(:dmt_advice).is_at_most(200) }
        #it { expect(subject).to validate_presence_of(:dmt_classification) }
        it { expect(subject).to validate_presence_of(:status) }

        it { expect(subject).to_not validate_presence_of(:mnemonic) }
        it { expect(subject).to_not ensure_length_of(:mnemonic).is_at_most(4) }
        it { expect(subject).to_not validate_presence_of(:cd5_portal_origin_code) }
        it { expect(subject).to_not validate_presence_of(:cd5_portal_destination_code) }
        it { expect(subject).to_not validate_presence_of(:mainframe_storage_type) }
        it { expect(subject).to_not ensure_length_of(:room_2_notes).is_at_most(500) }

      end

      context 'when user profile is room2' do
        let(:profile) { 'sala2' }
        it { expect(subject).to_not validate_presence_of(:file_name) }
        it { expect(subject).to_not ensure_length_of(:file_name).is_at_most(50) }
        it { expect(subject).to_not validate_presence_of(:file_description) }
        it { expect(subject).to_not ensure_length_of(:file_description).is_at_most(200) }
        it { expect(subject).to_not validate_presence_of(:created_in_sprint) }
        it { expect(subject).to_not validate_presence_of(:updated_in_sprint) }
        it { expect(subject).to_not validate_presence_of(:abbreviation) }
        it { expect(subject).to_not ensure_length_of(:abbreviation).is_at_most(3) }
        it { expect(subject).to_not validate_presence_of(:base_type) }
        it { expect(subject).to_not ensure_length_of(:book_mainframe).is_at_most(10) }
        it { expect(subject).to_not validate_presence_of(:periodicity) }
        it { expect(subject).to_not ensure_length_of(:periodicity_details).is_at_most(50) }
        it { expect(subject).to_not validate_presence_of(:data_retention_type) }
        it { expect(subject).to_not validate_presence_of(:extractor_file_type) }
        it { expect(subject).to_not ensure_length_of(:room_1_notes).is_at_most(500) }
        it { expect(subject).to_not ensure_length_of(:dmt_advice).is_at_most(200) }

        it { expect(subject).to validate_presence_of(:mnemonic) }
        it { expect(subject).to ensure_length_of(:mnemonic).is_at_most(4) }
        it { expect(subject).to validate_presence_of(:cd5_portal_origin_code) }
        it { expect(subject).to validate_presence_of(:cd5_portal_destination_code) }
        it { expect(subject).to validate_presence_of(:mainframe_storage_type) }
        it { expect(subject).to ensure_length_of(:room_2_notes).is_at_most(500) }
        it { expect(subject).to validate_presence_of(:status) }
      end
    end
  end

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

  describe "before_save calculate fields" do
    context "when the mnemonic is fill out" do
      let(:o) { FactoryGirl.create(:origin, mnemonic: "ABC") }

      it "the hive_table_name start with 'ORG_' append with the mnemonic" do
        expect(o.hive_table_name).to eq "ORG_ABC"
      end

      it "the hive_table_name not equal nil" do
        expect(o.hive_table_name).not_to eq nil
      end

      it "the cd5_portal_destination_name start with 'CD5.RETR.B' append with the mnemonic" do
        expect(o.cd5_portal_destination_name).to eq "CD5.RETR.BABC"
      end

      it "the cd5_portal_origin_name start with 'CD5.BASE.O' apend with the mnemonic" do
        expect(o.cd5_portal_origin_name).to eq "CD5.BASE.OABC"
      end
    end

    context "when the mnemonic is not fill out" do
      let(:o) { FactoryGirl.create(:origin, mnemonic: nil) }

      it "the hive_table_name start with 'ORG_' append with the mnemonic" do
        expect(o.hive_table_name).not_to eq "ORG_ABC"
      end

      it "the hive_table_name equal nil" do
        expect(o.hive_table_name).to eq nil
      end

      it "the cd5_portal_destination_name equal nil" do
        expect(o.cd5_portal_destination_name).to eq nil
      end

      it "the cd5_portal_origin_name equal nil" do
        expect(o.cd5_portal_origin_name).to eq nil
      end
    end
  end

end
