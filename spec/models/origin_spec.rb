require 'rails_helper'

describe Origin do
  let(:current_user_id) { FactoryGirl.create(:user, profile: profile).id }
  let(:profile) { 'sala1' }

  context "fields" do
    subject { FactoryGirl.build(:origin, current_user_id: current_user_id)  }

    context "validations" do
      context 'when user profile is room1' do
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
        it { expect(subject).to ensure_length_of(:dmt_advice).is_at_most(200) }
        it { expect(subject).to validate_presence_of(:dmt_classification) }
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
        it { expect(subject).to_not validate_presence_of(:dmt_classification) }

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
      @a = FactoryGirl.create(:origin, id: 1,    current_user_id: current_user_id)
      @b = FactoryGirl.create(:origin, id: 980,  current_user_id: current_user_id)
      @c = FactoryGirl.create(:origin, id: 10,   current_user_id: current_user_id)
      @d = FactoryGirl.create(:origin, id: 100,  current_user_id: current_user_id)
      @e = FactoryGirl.create(:origin, id: 1000, current_user_id: current_user_id)
    end

    it "generate codes successfully" do
      expect(@a.code).to eq "OR001"
      expect(@b.code).to eq "OR980"
      expect(@c.code).to eq "OR010"
      expect(@d.code).to eq "OR100"
      expect(@e.code).to eq "OR1000"
    end
  end

  context "scopes" do
    before do
      @origin1 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 2.hour, current_user_id: current_user_id)
      @origin2 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 8.hour, current_user_id: current_user_id)
      @origin3 = FactoryGirl.create(:origin, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 7.hour, current_user_id: current_user_id)
      @origin4 = FactoryGirl.create(:origin, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 6.hour, current_user_id: current_user_id)
      @origin5 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 5.hour, current_user_id: current_user_id)
      @origin6 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 4.hour, current_user_id: current_user_id)
      @origin7 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 3.hour, current_user_id: current_user_id)
      @origin8 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 2.days, current_user_id: current_user_id)
      @origin9 = FactoryGirl.create(:origin, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 1.hour, current_user_id: current_user_id)
    end

    context "statuses" do
      it "filters by status" do
        expect(Origin.draft.count).to       eq 3
        expect(Origin.development.count).to eq 4
        expect(Origin.done.count).to        eq 2
      end
    end

    context "recent" do
      it "orders the records by most recent changes" do
        expect(Origin.recent.limit(3)).to eq [@origin9, @origin1, @origin7]
      end
    end
  end

  context "before_save calculate fields" do
    subject { FactoryGirl.create(:origin, mnemonic: mnemonic, current_user_id: current_user_id) }

    context "when the mnemonic is not fill out" do
      let(:mnemonic) { "" }

      it "not calculates fields" do
        expect(subject.hive_table_name).to eq nil
        expect(subject.cd5_portal_destination_name).to eq nil
        expect(subject.cd5_portal_origin_name).to eq nil
      end
    end

    context "when the mnemonic is fill out" do
      let(:mnemonic) { 'ABC' }

      it "calculate fields correctly" do
        expect(subject.hive_table_name).to eq "ORG_ABC"
        expect(subject.cd5_portal_destination_name).to eq "CD5.RETR.BABC"
        expect(subject.cd5_portal_origin_name).to eq "CD5.BASE.OABC"
      end
    end
  end

  context ".status_screen_name" do
    subject { FactoryGirl.build(:origin, file_name: file_name, current_user_id: current_user_id) }

    context "when file_name is nil"  do
      let(:file_name) { nil }

      it "returns an empty string" do
        expect(subject.status_screen_name).to be_blank
      end
    end

    context "when file_name has value" do
      context "when file_name has less than 20 characters" do
        let(:file_name) { "testnamestring" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestring"
        end
      end

      context "when file_name has more than 20 characters" do
        let(:file_name) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestringbigger"
        end
      end
    end
  end
end
