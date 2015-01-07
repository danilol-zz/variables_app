require 'rails_helper'

describe Variable do
  let(:current_user_id) { FactoryGirl.create(:user).id }

  describe "scopes" do
    before do
      @variable1 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 2.hour, current_user_id: current_user_id)
      @variable2 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 8.hour, current_user_id: current_user_id)
      @variable3 = FactoryGirl.create(:variable, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 7.hour, current_user_id: current_user_id)
      @variable4 = FactoryGirl.create(:variable, status: Constants::STATUS[:PRODUCAO], updated_at: Time.now - 6.hour, current_user_id: current_user_id)
      @variable5 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 5.hour, current_user_id: current_user_id)
      @variable6 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 4.hour, current_user_id: current_user_id)
      @variable7 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 3.hour, current_user_id: current_user_id)
      @variable8 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2],    updated_at: Time.now - 9.hour, current_user_id: current_user_id)
      @variable9 = FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1],    updated_at: Time.now - 1.hour, current_user_id: current_user_id)
    end

    context "statuses" do
      it "filters by status" do
        expect(Variable.draft.count).to eq 3
        expect(Variable.development.count).to eq 4
        expect(Variable.done.count).to eq 2
      end
    end

    context "recent" do
      it "orders the records by most recent changes" do
        expect(Variable.recent.limit(3)).to eq [@variable9, @variable1, @variable7]
      end
    end
  end

  context "origin_fields_x_variables" do
    before do
      origin = FactoryGirl.create(:origin, current_user_id: current_user_id)
      o1 = FactoryGirl.create(:origin_field, field_name: "o1", origin: origin, current_user_id: current_user_id)
      o2 = FactoryGirl.create(:origin_field, field_name: "o2", origin: origin, current_user_id: current_user_id)
      o3 = FactoryGirl.create(:origin_field, field_name: "o3", origin: origin, current_user_id: current_user_id)
      @variable = FactoryGirl.create(:variable, origin_fields: [o1, o2, o3])
    end

    it "has relationship" do
      expect(@variable.origin_fields.count).to eq 3
      expect(@variable.origin_fields.map(&:field_name)).to include "o1", "o2", "o3"
    end
  end

  context "campaigns_x_variables" do
    before do
      c1 = FactoryGirl.create(:campaign, name: "c1", current_user_id: current_user_id)
      c2 = FactoryGirl.create(:campaign, name: "c2", current_user_id: current_user_id)
      c3 = FactoryGirl.create(:campaign, name: "c3", current_user_id: current_user_id)
      @variable = FactoryGirl.create(:variable)
      @variable.campaigns << [c1, c2, c3]
    end

    it "has relationship" do
      expect(@variable.campaigns.count).to eq 3
      expect(@variable.campaigns.map(&:name)).to include "c1", "c2", "c3"
    end
  end

  context "tables_x_variables" do
    before do
      t1 = FactoryGirl.create(:table, name: "t1", current_user_id: current_user_id)
      t2 = FactoryGirl.create(:table, name: "t2", current_user_id: current_user_id)
      t3 = FactoryGirl.create(:table, name: "t3", current_user_id: current_user_id)
      @variable = FactoryGirl.create(:variable)
      @variable.tables << [t1, t2, t3]
    end

    it "has relationship" do
      expect(@variable.tables.count).to eq 3
      expect(@variable.tables.map(&:name)).to include "t1", "t2", "t3"
    end
  end

  context "processids_x_variables" do
    before do
      p1 = FactoryGirl.create(:processid, mnemonic: "p1", current_user_id: current_user_id)
      p2 = FactoryGirl.create(:processid, mnemonic: "p2", current_user_id: current_user_id)
      p3 = FactoryGirl.create(:processid, mnemonic: "p3", current_user_id: current_user_id)
      @variable = FactoryGirl.create(:variable)
      @variable.processids << [p1, p2, p3]
    end

    it "has relationship" do
      expect(@variable.processids.count).to eq 3
      expect(@variable.processids.map(&:mnemonic)).to include "p1", "p2", "p3"
    end
  end

  context ".set_origin_fields" do
    context "on create" do
      subject { FactoryGirl.create(:variable) }

      context "with no origin_field selected" do
        it "not saves origin_field" do
          subject.set_origin_fields(nil)

          expect(subject.origin_fields.size).to eq 0
        end
      end

      context "with origin_fields selected" do
        before do
          @variable = FactoryGirl.build(:variable)
          origin = FactoryGirl.create(:origin, current_user_id: current_user_id)

          FactoryGirl.create(:origin_field, id: 1, field_name: "o1", origin: origin, current_user_id: current_user_id)
          FactoryGirl.create(:origin_field, id: 5, field_name: "o2", origin: origin, current_user_id: current_user_id)
          FactoryGirl.create(:origin_field, id: 9, field_name: "o3", origin: origin, current_user_id: current_user_id)
        end

        context "with one origin_field selected" do
          let(:variable_params) { {"5"=>"checked" } }

          it "saves origin_fields" do
            subject.set_origin_fields(variable_params, current_user_id)

            expect(subject.origin_fields.size).to eq 1
          end
        end

        context "with many origin_field selected" do
          let(:variable_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves origin_fields" do
            subject.set_origin_fields(variable_params, current_user_id)

            expect(subject.origin_fields.size).to eq 3
          end
        end
      end
    end

    context "on update" do
      before do
        origin = FactoryGirl.create(:origin, current_user_id: current_user_id)
        o1 = FactoryGirl.create(:origin_field, id:  1, field_name: "o1", origin: origin, current_user_id: current_user_id)
        o2 = FactoryGirl.create(:origin_field, id:  5, field_name: "o2", origin: origin, current_user_id: current_user_id)
        o3 = FactoryGirl.create(:origin_field, id:  9, field_name: "o3", origin: origin, current_user_id: current_user_id)
        o4 = FactoryGirl.create(:origin_field, id: 15, field_name: "o4", origin: origin, current_user_id: current_user_id)
        o5 = FactoryGirl.create(:origin_field, id: 19, field_name: "o5", origin: origin, current_user_id: current_user_id)
        @variable = FactoryGirl.create(:variable, origin_fields: [o1, o2])
      end

      context "with no origin_fields selected" do
        it "unsets saved origin_fields" do
          @variable.set_origin_fields
          @variable.save
          expect(@variable.origin_fields.count).to eq 0
        end
      end

      context "with origin_fields selected" do
        context "with one origin_fields selected" do
          let(:variable_params) { {"5"=>"checked" } }

          it "saves only last selected origin_fields" do
            @variable.set_origin_fields(variable_params, current_user_id)
            @variable.save
            expect(@variable.origin_fields.count).to eq 1
          end
        end

        context "with many origin_fields selected" do
          let(:variable_params) { {"15"=>"checked", "19" => "checked", "9" => "checked"} }

          it "saves origin_fields" do
            @variable.set_origin_fields(variable_params, current_user_id)
            @variable.save
            expect(@variable.origin_fields.count).to eq 3
          end
        end
      end
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:variable, id: 1)
      @b = FactoryGirl.create(:variable, id: 10)
      @c = FactoryGirl.create(:variable, id: 997)
      @d = FactoryGirl.create(:variable, id: 1000)
    end

    it "generates codes successfully" do
      expect(@a.code).to eq "VA001"
      expect(@b.code).to eq "VA010"
      expect(@c.code).to eq "VA997"
      expect(@d.code).to eq "VA1000"
    end
  end

  context ".status_screen_name" do
    subject { FactoryGirl.build(:variable, name: name).status_screen_name }

    context "when mnemonicn is nil"  do
      let(:name) { nil }

      it "returns an empty string" do
        expect(subject).to be_blank
      end
    end

    context "when name has value" do
      context "when name has less than 20 characters" do
        let(:name) { "testnamestring" }

        it "returns the same string" do
          expect(subject).to eq "testnamestring"
        end
      end

      context "when name has more than 20 characters" do
        let(:name) { "testnamestringbiggertha20characters" }

        it "returns the same string" do
          expect(subject).to eq "testnamestringbigger"
        end
      end
    end
  end
end
