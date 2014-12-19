require 'rails_helper'

describe Variable do
  let(:current_user_id) { @user.id }

  before { @user = FactoryGirl.create(:user) }

  describe "attributes validations" do
    context "statuses" do
      before do
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
        FactoryGirl.create(:variable, status: Constants::STATUS[:PRODUCAO])
        FactoryGirl.create(:variable, status: Constants::STATUS[:PRODUCAO])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA2])
        FactoryGirl.create(:variable, status: Constants::STATUS[:SALA1])
      end

      it "check the scopes" do
        expect(Variable.draft.count).to eq 3
        expect(Variable.development.count).to eq 4
        expect(Variable.done.count).to eq 2
      end
    end
  end

  context "origin_fields_x_variables" do
    before do
      origin = FactoryGirl.create(:origin, current_user_id: current_user_id)
      o1 = FactoryGirl.create(:origin_field, field_name: "o1", origin: origin)
      o2 = FactoryGirl.create(:origin_field, field_name: "o2", origin: origin)
      o3 = FactoryGirl.create(:origin_field, field_name: "o3", origin: origin)
      @variable = FactoryGirl.create(:variable, origin_fields: [o1, o2, o3])
    end

    it "has relationship" do
      expect(@variable.origin_fields.count).to eq 3
      expect(@variable.origin_fields.map(&:field_name)).to include "o1", "o2", "o3"
    end
  end

  context "campaigns_x_variables" do
    before do
      c1 = FactoryGirl.create(:campaign, name: "c1")
      c2 = FactoryGirl.create(:campaign, name: "c2")
      c3 = FactoryGirl.create(:campaign, name: "c3")
      @variable = FactoryGirl.create(:variable)
      @variable.campaigns << [c1, c2, c3]
    end

    it "should have relationship" do
      expect(@variable.campaigns.count).to eq 3
      expect(@variable.campaigns.map(&:name)).to include "c1", "c2", "c3"
    end
  end

  context "tables_x_variables" do
    before do
      t1 = FactoryGirl.create(:table, name: "t1")
      t2 = FactoryGirl.create(:table, name: "t2")
      t3 = FactoryGirl.create(:table, name: "t3")
      @variable = FactoryGirl.create(:variable)
      @variable.tables << [t1, t2, t3]
    end

    it "should have relationship" do
      expect(@variable.tables.count).to eq 3
      expect(@variable.tables.map(&:name)).to include "t1", "t2", "t3"
    end
  end

  context "processids_x_variables" do
    before do
      p1 = FactoryGirl.create(:processid, mnemonic: "p1")
      p2 = FactoryGirl.create(:processid, mnemonic: "p2")
      p3 = FactoryGirl.create(:processid, mnemonic: "p3")
      @variable = FactoryGirl.create(:variable)
      @variable.processids << [p1, p2, p3]
    end

    it "should have relationship" do
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
          origin = FactoryGirl.create(:origin)

          FactoryGirl.create(:origin_field, id: 1, field_name: "o1", origin: origin)
          FactoryGirl.create(:origin_field, id: 5, field_name: "o2", origin: origin)
          FactoryGirl.create(:origin_field, id: 9, field_name: "o3", origin: origin)
        end

        context "with one origin_field selected" do
          let(:variable_params) { {"5"=>"checked" } }

          it "saves origin_fields" do
            subject.set_origin_fields(variable_params, @user.id)

            expect(subject.origin_fields.size).to eq 1
          end
        end

        context "with many origin_field selected" do
          let(:variable_params) { {"1"=>"checked", "5" => "checked", "9" => "checked"} }

          it "saves origin_fields" do
            subject.set_origin_fields(variable_params, @user.id)

            expect(subject.origin_fields.size).to eq 3
          end
        end
      end
    end

    context "on update" do
      before do
        origin = FactoryGirl.create(:origin, )
        o1 = FactoryGirl.create(:origin_field, id:  1, field_name: "o1", origin: origin)
        o2 = FactoryGirl.create(:origin_field, id:  5, field_name: "o2", origin: origin)
        o3 = FactoryGirl.create(:origin_field, id:  9, field_name: "o3", origin: origin)
        o4 = FactoryGirl.create(:origin_field, id: 15, field_name: "o4", origin: origin)
        o5 = FactoryGirl.create(:origin_field, id: 19, field_name: "o5", origin: origin)
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
            @variable.set_origin_fields(variable_params, @user.id)
            @variable.save
            expect(@variable.origin_fields.count).to eq 1
          end
        end

        context "with many origin_fields selected" do
          let(:variable_params) { {"15"=>"checked", "19" => "checked", "9" => "checked"} }

          it "saves origin_fields" do
            @variable.set_origin_fields(variable_params, @user.id)
            @variable.save
            expect(@variable.origin_fields.count).to eq 3
          end
        end
      end
    end
  end

  context ".code" do
    before do
      @a = FactoryGirl.create(:variable)
      @b = FactoryGirl.create(:variable)
      @c = FactoryGirl.create(:variable, id: 10)
      @d = FactoryGirl.create(:variable, id: 100)
      @e = FactoryGirl.create(:variable, id: 1000)
    end

    it "should generate right codes" do
      expect(@a.code).to eq "VA001"
      expect(@b.code).to eq "VA002"
      expect(@c.code).to eq "VA010"
      expect(@d.code).to eq "VA100"
      expect(@e.code).to eq "VA1000"
    end
  end
end
