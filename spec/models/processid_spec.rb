require 'rails_helper'

describe Processid do
  let(:profile) { 'sala2' }

  before do
    user = FactoryGirl.create(:user, profile: profile)

    subject.current_user_id = user.id
  end

  context "statuses" do
    before do
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:processid, status: Constants::STATUS[:SALA1])
      FactoryGirl.create(:processid, status: Constants::STATUS[:PRODUCAO])
      FactoryGirl.create(:processid, status: Constants::STATUS[:PRODUCAO])
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

  context ".set_variables" do
    context "on create" do
      before do
        FactoryGirl.create(:variable, id: 1, name: "v1")
        FactoryGirl.create(:variable, id: 5, name: "v2")
        FactoryGirl.create(:variable, id: 9, name: "v3")

        @processid = FactoryGirl.create(:processid)
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


  describe "before_save calculate fields" do
    context "when the mnemonic is fill out" do
      let(:resource) { FactoryGirl.create(:processid, mnemonic: "XPTO") }

      it "the 'var_table_name' begin with string 'VAR_' append with the mnemonic value" do
        expect(resource.var_table_name).to eq "VAR_XPTO"
      end

      it "the 'var_table_name' NOT equal nil" do
        expect(resource.var_table_name).not_to eq nil
      end
    end

    context "when the mnemonic is not fill out" do
      let(:resource) { FactoryGirl.create(:processid, mnemonic: nil) }

      it "the 'var_table_name' NOT begin with string 'VAR_' append with the mnemonic value" do
        expect(resource.var_table_name).not_to eq "VAR_XPTO"
      end

      it "the 'var_table_name' equal nil" do
        expect(resource.var_table_name).to eq nil
      end
    end

    context "when the process_number is fill out" do
      let(:resource) { FactoryGirl.create(:processid, process_number: 100) }

      it "the 'routine_name' begin with string 'CD5PV' append with the process_number" do
        expect(resource.routine_name).to eq "CD5PV#{resource.process_number}"
      end

      it "the 'routine_name' NOT equal nil" do
        expect(resource.routine_name).not_to eq nil
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

