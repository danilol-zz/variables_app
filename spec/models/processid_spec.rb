require 'rails_helper'

describe Processid do
  let(:current_user_id) { FactoryGirl.create(:user, profile: profile).id }

  let(:profile) { 'sala2' }

  context 'validations' do
    subject { FactoryGirl.build(:processid, current_user_id: current_user_id)  }

    it { expect(subject).to validate_presence_of(:process_number) }
    it { expect(subject).to validate_presence_of(:mnemonic) }
    it { expect(subject).to validate_presence_of(:routine_name) }
    it { expect(subject).to validate_presence_of(:var_table_name) }
    it { expect(subject).to validate_presence_of(:conference_rule) }
    it { expect(subject).to ensure_length_of(:conference_rule).is_at_most(100) }
    it { expect(subject).to validate_presence_of(:acceptance_percent) }
    it { expect(subject).to validate_presence_of(:counting_rule) }
    it { expect(subject).to ensure_length_of(:counting_rule).is_at_most(100) }
    it { expect(subject).to validate_presence_of(:notes) }
    it { expect(subject).to ensure_length_of(:notes).is_at_most(500) }
  end

  context "scopes" do
    before do
      @processid1 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 2.hour, current_user_id: current_user_id)
      @processid2 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 8.hour, current_user_id: current_user_id)
      @processid3 = FactoryGirl.create(:processid, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 7.hour, current_user_id: current_user_id)
      @processid4 = FactoryGirl.create(:processid, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 6.hour, current_user_id: current_user_id)
      @processid5 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 5.hour, current_user_id: current_user_id)
      @processid6 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 4.hour, current_user_id: current_user_id)
      @processid7 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 3.hour, current_user_id: current_user_id)
      @processid8 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 2.days, current_user_id: current_user_id)
      @processid9 = FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 1.hour, current_user_id: current_user_id)
    end

    context "statuses" do
      it "filters by status" do
        expect(Processid.draft.count).to eq 3
        expect(Processid.development.count).to eq 4
        expect(Processid.done.count).to eq 2
      end
    end

    context "recent" do
      it "orders the records by most recent changes" do
        expect(Processid.recent.limit(3)).to eq [@processid9, @processid1, @processid7]
      end
    end
  end

  context ".set_variables" do
    context "on create" do
      before do
        FactoryGirl.create(:variable, id: 1, name: "v1")
        FactoryGirl.create(:variable, id: 5, name: "v2")
        FactoryGirl.create(:variable, id: 9, name: "v3")

        @processid = FactoryGirl.create(:processid, current_user_id: current_user_id)
      end

      context "with no variables selected" do
        it "not saves variables" do
          @processid.set_variables(nil)

          expect(@processid.variables.count).to eq 0
        end
      end

      context "with variables selected" do
        context "with one variable selected" do
          let(:processid_params) { {"5"=>"checked" } }

          it "saves variables" do
            @processid.set_variables(processid_params)

            expect(@processid.variables.count).to eq 1
          end
        end

        context "with many variable selected" do
          let(:processid_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves variables" do
            @processid.set_variables(processid_params)

            expect(@processid.variables.count).to eq 3
          end
        end
      end
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:processid, id: 1,    current_user_id: current_user_id)
      @b = FactoryGirl.create(:processid, id: 80,   current_user_id: current_user_id)
      @c = FactoryGirl.create(:processid, id: 810,  current_user_id: current_user_id)
      @d = FactoryGirl.create(:processid, id: 100,  current_user_id: current_user_id)
      @e = FactoryGirl.create(:processid, id: 1000, current_user_id: current_user_id)
    end

    it "generates right codes" do
      expect(@a.code).to eq "PR001"
      expect(@b.code).to eq "PR080"
      expect(@c.code).to eq "PR810"
      expect(@d.code).to eq "PR100"
      expect(@e.code).to eq "PR1000"
    end
  end

  describe "before_save calculate fields" do
    subject { FactoryGirl.create(:processid, mnemonic: mnemonic, current_user_id: current_user_id) }

    context "when the mnemonic is fill out" do
      let(:mnemonic) { "XPTO" }

      it "calculates fields correctly" do
        expect(subject.var_table_name).to eq "VAR_XPTO"
      end
    end
  end

  context ".status_screen_name" do
    subject { FactoryGirl.build(:processid, mnemonic: mnemonic) }

    context "when mnemonicn is nil"  do
      let(:mnemonic) { nil }

      it "returns an empty string" do
        expect(subject.status_screen_name).to be_blank
      end
    end

    context "when mnemonic has value" do
      context "when mnemonic has less than 20 characters" do
        let(:mnemonic) { "testnamestring" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestring"
        end
      end

      context "when mnemonic has more than 20 characters" do
        let(:mnemonic) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestringbigger"
        end
      end
    end
  end
end

