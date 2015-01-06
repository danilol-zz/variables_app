require 'rails_helper'

describe OriginField do
  let(:current_user_id) { FactoryGirl.create(:user, profile: profile).id }
  let(:profile) { 'sala1' }

  describe 'validations' do
    subject { FactoryGirl.build(:origin_field, current_user_id: current_user_id)  }

    describe 'when user profile is room1' do
      it { expect(subject).to validate_presence_of(:field_name) }
      it { expect(subject).to validate_presence_of(:data_type) }
      it { expect(subject).to validate_inclusion_of(:data_type).in_array(Constants::DATA_TYPES) }
      it { expect(subject).to ensure_length_of(:mask).is_at_most(30) }
      it { expect(subject).to validate_presence_of(:position) }
      it { expect(subject).to validate_presence_of(:width) }

      context 'when profile user is room1 and data type is numeric' do
        let(:origin_field) { FactoryGirl.build(:origin_field, data_type: 'Numérico', current_user_id: current_user_id) }

        it { expect(origin_field).to validate_presence_of(:decimal) }
      end
    end

    describe 'when user profile is room2' do
      let(:profile) { 'sala2' }

      context 'when profile user is room2 and will use and and is key are false' do
        let(:origin_field) { FactoryGirl.build(:origin_field, will_use: true, is_key: false, current_user_id: current_user_id) }

        it { expect(origin_field).to validate_presence_of(:cd5_variable_number) }
      end

      context 'when profile user is room2 and cd5 variable number is not null' do
        let(:origin_field) { FactoryGirl.build(:origin_field, cd5_variable_number: 1, current_user_id: current_user_id) }

        it { expect(origin_field).to validate_presence_of(:cd5_output_order) }
      end

      it { expect(subject).to_not validate_presence_of(:field_name) }
      it { expect(subject).to_not validate_presence_of(:data_type) }
      it { expect(subject).to_not validate_inclusion_of(:data_type).in_array(Constants::DATA_TYPES) }
      it { expect(subject).to_not ensure_length_of(:mask).is_at_most(30) }
      it { expect(subject).to_not validate_presence_of(:position) }
      it { expect(subject).to_not validate_presence_of(:width) }
      it { expect(subject).to_not validate_presence_of(:is_key) }

      context 'when profile user is not room1 and data type is not numeric' do
        let(:origin_field) { FactoryGirl.build(:origin_field, data_type: 'Numérico', current_user_id: current_user_id) }

        it { expect(origin_field).to_not validate_presence_of(:decimal) }
        it { expect(origin_field).to_not validate_presence_of(:will_use) }
        it { expect(origin_field).to_not validate_presence_of(:has_signal) }
      end

    end
  end

  context "origin_fields_x_variables" do
    before do
      FactoryGirl.create(:origin, current_user_id: current_user_id)
      v1 = FactoryGirl.create(:variable, name: "v1")
      v2 = FactoryGirl.create(:variable, name: "v2")
      v3 = FactoryGirl.create(:variable, name: "v3")

      @origin_field = FactoryGirl.create(:origin_field, variables: [v1, v2, v3], current_user_id: current_user_id)
    end

    it "has relationship" do
      expect(@origin_field.variables.count).to eq 3
      expect(@origin_field.variables.map(&:name)).to include "v1", "v2", "v3"
    end
  end

  context '.text_parser' do
    let(:origin_id) { 1 }
    let(:text_parser) { OriginField.text_parser(org_type, str, origin_id, current_user_id) }

    context 'with invalid content' do
      context 'when org_type is mainfame' do
        let(:org_type) { "mainframe" }

        context "when string is empty" do
          let(:str) { "" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is to small" do
          let(:str) { "123" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is name invalid" do
          let(:str) { "  3   3 TIP!                                  X(30)     AN      1     30     30" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is origin_pic invalid" do
          let(:str) { "  3   3 TIPO                                  X 30)     AN      1     30     30" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is fmbase_format_type invalid" do
          let(:str) { "  3   3 TIPO                                  X(30)     AP      1     30     30" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is start invalid" do
          let(:str) { "  3   3 TIPO                                  X(30)     AN      1A    30     30" }
          it { expect(text_parser).to be_nil }
        end

        context "when string is width invalid" do
          let(:str) { "  3   3 TIPO                                  X(30)     AN      1     30     3A" }
          it { expect(text_parser).to be_nil }
        end

        context "inverted type arquivo mainframe -> base hadoop" do
          let(:str) { '"dat_ref","dat_ref","","<Undefined>"' }
          it { expect(text_parser).to be_nil }
        end
      end

      context 'when org_type is arquivo' do
        let(:str) { "  3   3 TIPO                                  X(30)     AN      1     30     30" }
        let(:org_type) { "arquivo" }

        context "when org_type is invalid" do
          it { expect(text_parser).to be_nil }
        end
      end

      context 'when org_type is hadoop' do
        let(:org_type) { "hadoop" }

        context "when more fields then expect" do
          let(:str) { '"dat_ref","dat_ref","","<Undefined>","<Undefined>"' }
          it { expect(text_parser).to be_nil }
        end

        context "when less fields then expect" do
          let(:str) { '"dat_ref","dat_ref",""' }
          it { expect(text_parser).to be_nil }
        end

        context "when invalid first field" do
          let(:str) { '"dat@ref","dat_ref","","<Undefined>"' }
          it { expect(text_parser).to be_nil }
        end

        context "inverted type base hadoop -> arquivo mainframe" do
          let(:str) { "  3   3 TIPO                                  X(30)     AN      1     30     30" }
          it { expect(text_parser).to be_nil }
        end
      end
    end

    context 'with valid content' do
      context 'when org_type is hadoop' do
        let(:org_type) { "hadoop" }

        context "success" do
          let(:str) { '"dat_ref","dat_ref","","<Undefined>"' }

          it "has following data" do
            expect(text_parser).to be_kind_of(OriginField)
            expect(text_parser.field_name).to eq "dat_ref"
            expect(text_parser.origin_pic).to eq "X(255)"
            expect(text_parser.data_type).to  eq "Alfanumérico"
            expect(text_parser.position).to   eq 0
            expect(text_parser.width).to      eq 0
          end
        end
      end

      context 'when org_type is mainframe' do
        let(:org_type) { "mainframe" }

        context "success" do
          let(:str) { "  3   3 TIPO                                  X(30)     AN      1     30     30" }

          it "has the following data" do
            expect(text_parser).to be_kind_of(OriginField)
            expect(text_parser.field_name).to eq "TIPO"
            expect(text_parser.origin_pic).to eq "X(30)"
            expect(text_parser.data_type).to eq "Alfanumérico"
            expect(text_parser.position).to eq 1
            expect(text_parser.width).to eq 30
          end
        end
      end
    end
  end

  describe "before_save calculate fields" do
    context "define cd5_variable_name concatenate cd5_variable_number and field_name" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, field_name: "TXT_VALUE", current_user_id: current_user_id) }

      it "when cd5_variable_number and field_name is fill out" do
        expect(o.cd5_variable_name).to eq "555TXT_VALUE"
      end
    end

    context "define cd5_format according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_format).to eq "1"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_format).to eq "2"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_format).to eq "4"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_format).to eq "3"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_format).to eq "2"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado com Vírgula" do
        expect(o6.cd5_format).to eq "4"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_format).to eq "6"
      end

    end

    context "define cd5_format_desc according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_format_desc).to eq "character"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_format_desc).to eq "numeric"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_format_desc).to eq "numeric"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_format_desc).to eq "Data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_format_desc).to eq "numeric"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado com Vírgula" do
        expect(o6.cd5_format_desc).to eq "numeric"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_format_desc).to eq "numeric"
      end

    end

    context "define default_value according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.default_value).to eq "_"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.default_value).to eq 0
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o3.default_value).to eq 0
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.default_value).to eq 0
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.default_value).to eq 0
      end

      let(:o5) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado com Vírgula" do
        expect(o5.default_value).to eq 0
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o6.default_value).to eq 0
      end

    end

    context "define cd5_origin_format_desc according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_origin_format_desc).to eq "character"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_origin_format_desc).to eq "Data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado com Vírgula" do
        expect(o6.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_origin_format_desc).to eq "numeric"
      end

    end

    context "define cd5_origin_format according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_origin_format).to eq "1"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_origin_format).to eq "2"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_origin_format).to eq "4"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_origin_format).to eq "3"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_origin_format).to eq "2"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Compactado com Vírgula" do
        expect(o6.cd5_origin_format).to eq "4"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_origin_format).to eq "6"
      end

    end

    context "define generic_data_type according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico", current_user_id: current_user_id) }
      it "equal Alfanumérico" do
        expect(o.generic_data_type).to eq "texto"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico", current_user_id: current_user_id) }
      it "equal Numérico" do
        expect(o1.generic_data_type).to eq "numero"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado", current_user_id: current_user_id) }
      it "equal Compactado" do
        expect(o2.generic_data_type).to eq "numero"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data", current_user_id: current_user_id) }
      it "equal Data" do
        expect(o3.generic_data_type).to eq "data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula", current_user_id: current_user_id) }
      it "equal Numérico com vírgula" do
        expect(o4.generic_data_type).to eq "numero"
      end

      let(:o5) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com Vírgula", current_user_id: current_user_id) }
      it "equal Compactado com Vírgula" do
        expect(o5.generic_data_type).to eq "numero"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe", current_user_id: current_user_id) }
      it "equal Binário Mainframe" do
        expect(o6.generic_data_type).to eq "numero"
      end

    end

    context "define fmbase_format_type according the data_type" do
      subject { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: fmbase_format_type, current_user_id: current_user_id)  }

      context "when fmbase_format_type is Alfanumérico" do
        let(:fmbase_format_type) { "Alfanumérico" }
        it { expect(subject.fmbase_format_type).to eq "AN" }
      end

      context "when fmbase_format_type is Numérico" do
        let(:fmbase_format_type) { "Numérico" }
        it { expect(subject.fmbase_format_type).to eq "ZD" }
      end

      context "when fmbase_format_type is Compactado" do
        let(:fmbase_format_type) { "Compactado" }
        it { expect(subject.fmbase_format_type).to eq "PD" }
      end

      context "when fmbase_format_type is Data" do
        let(:fmbase_format_type) { "Data" }
        it { expect(subject.fmbase_format_type).to eq "ZD" }
      end

      context "when fmbase_format_type is Numérico com vírgula" do
        let(:fmbase_format_type) { "Numérico com vírgula" }
        it { expect(subject.fmbase_format_type).to eq "ZD" }
      end

      context "when fmbase_format_type is Compactado com Vírgula" do
        let(:fmbase_format_type) { "Compactado com Vírgula" }
        it { expect(subject.fmbase_format_type).to eq "PD" }
      end

      context "when fmbase_format_type is Mainframe" do
        let(:fmbase_format_type) { "Binário Mainframe" }
        it { expect(subject.fmbase_format_type).to eq "BI" }
      end
    end
  end
end
