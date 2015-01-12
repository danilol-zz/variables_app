require 'rails_helper'

describe Table do
  let(:current_user_id) { FactoryGirl.create(:user, profile: profile).id }

  let(:profile) { 'sala1' }

  context "scopes" do
    before do
      @table1 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 2.hour, current_user_id: current_user_id)
      @table2 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 8.hour, current_user_id: current_user_id)
      @table3 = FactoryGirl.create(:table, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 7.hour, current_user_id: current_user_id)
      @table4 = FactoryGirl.create(:table, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 6.hour, current_user_id: current_user_id)
      @table5 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 5.hour, current_user_id: current_user_id)
      @table6 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 4.hour, current_user_id: current_user_id)
      @table7 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 3.hour, current_user_id: current_user_id)
      @table8 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 2.days, current_user_id: current_user_id)
      @table9 = FactoryGirl.create(:table, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 1.hour, current_user_id: current_user_id)
    end

    context "statuses" do
      it "filters by status" do
        expect(Table.draft.count).to eq 3
        expect(Table.development.count).to eq 4
        expect(Table.done.count).to eq 2
      end
    end

    context "recent" do
      it "orders the records by most recent changes" do
        expect(Table.recent.limit(3)).to eq [@table9, @table1, @table7]
      end
    end
  end

  context "table_x_variables" do
    before do
      v1 = FactoryGirl.create(:variable, name: "v1")
      v2 = FactoryGirl.create(:variable, name: "v2")
      v3 = FactoryGirl.create(:variable, name: "v3")
      @table = FactoryGirl.create(:table, variables: [v1, v2, v3], current_user_id: current_user_id)
    end

    it "has relationship" do
      expect(@table.variables.count).to eq 3
      expect(@table.variables.map(&:name)).to include "v1", "v2", "v3"
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:table, id: 1 ,   current_user_id: current_user_id)
      @b = FactoryGirl.create(:table, id: 80,   current_user_id: current_user_id)
      @c = FactoryGirl.create(:table, id: 10,   current_user_id: current_user_id)
      @d = FactoryGirl.create(:table, id: 100,  current_user_id: current_user_id)
      @e = FactoryGirl.create(:table, id: 1000, current_user_id: current_user_id)
    end

    it "generates right codes" do
      expect(@a.code).to eq "TA001"
      expect(@b.code).to eq "TA080"
      expect(@c.code).to eq "TA010"
      expect(@d.code).to eq "TA100"
      expect(@e.code).to eq "TA1000"
    end
  end

  context ".set_variables" do
    context "on create" do
      before do
        FactoryGirl.create(:variable, id: 1, name: "v1")
        FactoryGirl.create(:variable, id: 5, name: "v2")
        FactoryGirl.create(:variable, id: 9, name: "v3")

        @table = FactoryGirl.build(:table, current_user_id: current_user_id)
        @table.save
      end

      context "with no variables selected" do
        it "not saves variables" do
          @table.set_variables(nil)

          expect(@table.variables.count).to eq 0
        end
      end

      context "with variables selected" do
        context "with one variable selected" do
          let(:table_params) { {"5"=>"checked" } }

          it "saves variables" do
            @table.set_variables(table_params)

            expect(@table.variables.count).to eq 1
          end
        end

        context "with many variable selected" do
          let(:table_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves variables" do
            @table.set_variables(table_params)

            expect(@table.variables.count).to eq 3
          end
        end
      end
    end

    context "on update" do
      before do
        v1 = FactoryGirl.create(:variable, id: 1, name: "v1")
        v2 = FactoryGirl.create(:variable, id: 5, name: "v2")
        v3 = FactoryGirl.create(:variable, id: 9, name: "v3")
        v4 = FactoryGirl.create(:variable, id: 15, name: "v4")
        v5 = FactoryGirl.create(:variable, id: 19, name: "v5")
        @table = FactoryGirl.create(:table, variables: [v1, v2], current_user_id: current_user_id)
      end

      context "with no variables selected" do
        it "unsets saved variables" do
          @table.set_variables
          @table.save
          expect(@table.variables.count).to eq 0
        end
      end

      context "with variables selected" do
        context "with one variable selected" do
          let(:table_params) { {"5"=>"checked" } }

          it "saves only last selected variables" do
            @table.set_variables(table_params)
            @table.save
            expect(@table.variables.count).to eq 1
          end
        end

        context "with many variable selected" do
          let(:table_params) { {"15"=>"checked", "19" => "checked", "9" => "checked"} }

          it "saves variables" do
            @table.set_variables(table_params)
            @table.save
            expect(@table.variables.count).to eq 3
          end
        end
      end
    end
  end

  describe "before_save calculate fields of Table" do
    subject { FactoryGirl.create(:table, mnemonic: mnemonic, current_user_id: current_user_id) }

    context "when the mnemonic field was not filled" do
      let(:mnemonic) { nil }

      it "not calculates fields" do
        expect(subject.hive_table).to be_nil
      end
    end

    context "when the mnemonic field was filled" do
      let(:mnemonic) { "XPTO" }

      it "calculates field correctly" do
        expect(subject.hive_table).to eq "TAB_XPTO"
      end
    end
  end

  context ".status_screen_name" do
    subject { FactoryGirl.build(:table, logic_table_name: logic_table_name, current_user_id: current_user_id) }

    context "when logic_table_name is nil"  do
      let(:logic_table_name) { nil }

      it "returns an empty string" do
        expect(subject.status_screen_name).to be_blank
      end
    end

    context "when logic_table_name has value" do
      context "when name has less than 20 characters" do
        let(:logic_table_name) { "testnamestring" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestring"
        end
      end

      context "when logic_table_name has more than 20 characters" do
        let(:logic_table_name) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject.status_screen_name).to eq "testnamestringbigger"
        end
      end
    end
  end
end
