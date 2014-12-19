require 'rails_helper'

describe Table do
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

    it "checks the scopes" do
      expect(Table.draft.count).to eq 3
      expect(Table.development.count).to eq 4
      expect(Table.done.count).to eq 2
    end
  end

  context "table_x_variables" do
    before do
      v1 = FactoryGirl.create(:variable, name: "v1")
      v2 = FactoryGirl.create(:variable, name: "v2")
      v3 = FactoryGirl.create(:variable, name: "v3")
      @table = FactoryGirl.create(:table, variables: [v1, v2, v3])
    end

    it "has relationship" do
      expect(@table.variables.count).to eq 3
      expect(@table.variables.map(&:name)).to include "v1", "v2", "v3"
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

    it "generates right codes" do
      expect(@a.code).to eq "TA001"
      expect(@b.code).to eq "TA002"
      expect(@c.code).to eq "TA010"
      expect(@d.code).to eq "TA100"
      expect(@e.code).to eq "TA1000"
    end
  end

  context ".set_variables" do
    context "on create" do
      subject(:saved_table) { @table.save }

      before do
        @table = FactoryGirl.build(:table)
        FactoryGirl.create(:variable, id: 1, name: "v1")
        FactoryGirl.create(:variable, id: 5, name: "v2")
        FactoryGirl.create(:variable, id: 9, name: "v3")
      end

      context "with no variables selected" do
        it "not saves variables" do
          @table.set_variables(nil)
          expect{saved_table}.to_not change{@table.variables.count}
        end
      end

      context "with variables selected" do
        context "with one variable selected" do
          let(:table_params) { {"5"=>"checked" } }

          it "saves variables" do
            @table.set_variables(table_params)
            expect{subject}.to change{@table.variables.count}.by(1)
          end
        end

        context "with many variable selected" do
          let(:table_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves variables" do
            @table.set_variables(table_params)
            expect{subject}.to change{@table.variables.count}.by(3)
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
        @table = FactoryGirl.create(:table, variables: [v1, v2])
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
    context "when the mnemonic field was filled" do

      before do
        @a = FactoryGirl.create(:table, mnemonic: "XPTO")
      end

      it "the hive_table has the begin 'TAB_' concatenated with the mnemonic" do
        expect(@a.hive_table) == "TAB_XPTO"
      end

      it "the hive_table has the begin 'TAB_' NOT concatenated with the mnemonic" do
        expect(@a.hive_table) != "TAB_qqqqq"
      end
    end

    context "when the mnemonic field was not filled" do

      before do
        @a = FactoryGirl.create(:table)
      end

      it "the hive_table has the nil value" do
        expect(@a.hive_table) == nil
      end
    end
  end

end
