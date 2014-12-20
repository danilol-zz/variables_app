require 'rails_helper'

describe OriginField do
  before do
    user = FactoryGirl.create(:user, profile: profile)
    subject.current_user_id = user.id
  end

  let(:profile) { 'room1' }

  context "origin_fields_x_variables" do
    before do
      FactoryGirl.create(:origin, current_user_id: subject.current_user.id)
      v1 = FactoryGirl.create(:variable, name: "v1")
      v2 = FactoryGirl.create(:variable, name: "v2")
      v3 = FactoryGirl.create(:variable, name: "v3")
      @origin_field = FactoryGirl.create(:origin_field, variables: [v1, v2, v3])
    end

    it "has relationship" do
      expect(@origin_field.variables.count).to eq 3
      expect(@origin_field.variables.map(&:name)).to include "v1", "v2", "v3"
    end
  end

  context '.text_parser' do
    let(:origin_id) { 1 }
    let(:text_parser) { OriginField.text_parser(org_type, @str, origin_id, subject.current_user_id) }

    context 'with invalid content' do
      context 'when org_type is mainfame' do
        let(:org_type) { "mainframe" }

        it "should return error when string is empty" do
          @str = ""
          expect(text_parser).to eq nil
        end

        it "should return error when string is to small" do
          @str = "123"
          expect(text_parser).to eq nil
        end

        it "should return error when string is name invalid" do
          @str = "  3   3 TIP!                                  X(30)     AN      1     30     30"
          expect(text_parser).to eq nil
        end

        it "should return error when string is origin_pic invalid" do
          @str = "  3   3 TIPO                                  X 30)     AN      1     30     30"
          expect(text_parser).to eq nil
        end

        it "should return error when string is fmbase_format_type invalid" do
          @str = "  3   3 TIPO                                  X(30)     AP      1     30     30"
          expect(text_parser).to eq nil
        end

        it "should return error when string is start invalid" do
          @str = "  3   3 TIPO                                  X(30)     AN      1A    30     30"
          expect(text_parser).to eq nil
        end

        it "should return error when string is width invalid" do
          @str = "  3   3 TIPO                                  X(30)     AN      1     30     3A"
          expect(text_parser).to eq nil
        end

        it "should return error inverted type arquivo mainframe -> base hadoop" do
          @str = '"dat_ref","dat_ref","","<Undefined>"'
          expect(text_parser).to eq nil
        end
      end

      context 'when org_type is arquivo' do
        let(:org_type) { "arquivo" }

        it "should return erro when org_type is invalid" do
          @str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
          expect(text_parser).to eq nil
        end
      end

      context 'when org_type is hadoop' do
        let(:org_type) { "hadoop" }

        it "should return erro when more fields then expect" do
          @str = '"dat_ref","dat_ref","","<Undefined>","<Undefined>"'
          expect(text_parser).to eq nil
        end

        it "should return erro when less fields then expect" do
          @str = '"dat_ref","dat_ref",""'
          expect(text_parser).to eq nil
        end

        it "should return erro when invalid first field" do
          @str = '"dat@ref","dat_ref","","<Undefined>"'
          expect(text_parser).to eq nil
        end

        it "should return error inverted type base hadoop -> arquivo mainframe" do
          @str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
          expect(text_parser).to eq nil
        end
      end
    end

    context 'with valid content' do
      context 'when org_type is hadoop' do
        let(:org_type) { "hadoop" }

        it "should save the object succesfully generic" do
          @str = '"dat_ref","dat_ref","","<Undefined>"'
          expect(text_parser).to be_kind_of(OriginField)
          expect(text_parser.field_name).to eq "dat_ref"
          expect(text_parser.origin_pic).to eq "X(255)"
          expect(text_parser.data_type).to  eq "alfanumerico"
          expect(text_parser.position).to   eq 0
          expect(text_parser.width).to      eq 0
        end
      end

      context 'when org_type is mainframe' do
        let(:org_type) { "mainframe" }

        it "should save the object succesfully mainframe" do
          @str = "  3   3 TIPO                                  X(30)     AN      1     30     30"

          expect(text_parser).to be_kind_of(OriginField)
          expect(text_parser.field_name).to eq "TIPO"
          expect(text_parser.origin_pic).to eq "X(30)"
          expect(text_parser.data_type).to eq "alfanumerico"
          expect(text_parser.position).to eq 1
          expect(text_parser.width).to eq 30
        end
      end
    end
  end

  describe "before_save calculate fields" do

    context "define cd5_variable_name concatenate cd5_variable_number and field_name" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, field_name: "TXT_VALUE") }

      it "when cd5_variable_number and field_name is fill out" do
        expect(o.cd5_variable_name).to eq "555TXT_VALUE"
      end
    end

    context "define cd5_format according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_format).to eq "1"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_format).to eq "2"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_format).to eq "4"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_format).to eq "3"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_format).to eq "2"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Compactado com vírgula" do
        expect(o6.cd5_format).to eq "4"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_format).to eq "6"
      end

      let(:o8) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "----") }
      it "when cd5_variable_number is fill and data_type equal ----" do
        expect(o8.cd5_format).to eq nil
      end
    end

    context "define cd5_format_desc according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_format_desc).to eq "character"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_format_desc).to eq "numeric"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_format_desc).to eq "numeric"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_format_desc).to eq "data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_format_desc).to eq "numeric"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Compactado com vírgula" do
        expect(o6.cd5_format_desc).to eq "numeric"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_format_desc).to eq "numeric"
      end

      let(:o8) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "----") }
      it "when cd5_variable_number is fill and data_type equal ----" do
        expect(o8.cd5_format_desc).to eq nil
      end
    end

    context "define default_value according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.default_value).to eq "_"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.default_value).to eq 0
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o3.default_value).to eq 0
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.default_value).to eq 0
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "----") }
      it "when cd5_variable_number is fill and data_type equal ----" do
        expect(o4.default_value).to eq nil
      end
    end

    context "define cd5_origin_format_desc according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_origin_format_desc).to eq "character"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_origin_format_desc).to eq "data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Compactado com vírgula" do
        expect(o6.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_origin_format_desc).to eq "numeric"
      end

      let(:o8) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "----") }
      it "when cd5_variable_number is fill and data_type equal ----" do
        expect(o8.cd5_origin_format_desc).to eq nil
      end
    end

    context "define cd5_origin_format according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "when cd5_variable_number is fill and data_type equal Alfanumérico" do
        expect(o.cd5_origin_format).to eq "1"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "when cd5_variable_number is fill and data_type equal Numérico" do
        expect(o1.cd5_origin_format).to eq "2"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "when cd5_variable_number is fill and data_type equal Compactado" do
        expect(o2.cd5_origin_format).to eq "4"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "when cd5_variable_number is fill and data_type equal Data" do
        expect(o3.cd5_origin_format).to eq "3"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Numérico com vírgula" do
        expect(o4.cd5_origin_format).to eq "2"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "when cd5_variable_number is fill and data_type equal Compactado com vírgula" do
        expect(o6.cd5_origin_format).to eq "4"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "when cd5_variable_number is fill and data_type equal Binário Mainframe" do
        expect(o7.cd5_origin_format).to eq "6"
      end

      let(:o8) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "----") }
      it "when cd5_variable_number is fill and data_type equal ----" do
        expect(o8.cd5_origin_format).to eq nil
      end
    end

    context "define generic_data_type according the data_type" do
      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "equal Alfanumérico" do
        expect(o.generic_data_type).to eq "texto"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "equal Numérico" do
        expect(o1.generic_data_type).to eq "numero"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "equal Compactado" do
        expect(o2.generic_data_type).to eq "numero"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "equal Data" do
        expect(o3.generic_data_type).to eq "data"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "equal Numérico com vírgula" do
        expect(o4.generic_data_type).to eq "numero"
      end

      let(:o5) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "equal Compactado com vírgula" do
        expect(o5.generic_data_type).to eq "numero"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "equal Binário Mainframe" do
        expect(o6.generic_data_type).to eq "numero"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "---") }
      it "equal Binário Mainframe" do
        expect(o7.generic_data_type).to eq nil
      end
    end

    context "define fmbase_format_type according the data_type" do

      let(:o) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Alfanumérico") }
      it "equal Alfanumérico" do
        expect(o.fmbase_format_type).to eq "AN"
      end

      let(:o1) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico") }
      it "equal Numérico" do
        expect(o1.fmbase_format_type).to eq "ZD"
      end

      let(:o2) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado") }
      it "equal Compactado" do
        expect(o2.fmbase_format_type).to eq "PD"
      end

      let(:o3) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Data") }
      it "equal Data" do
        expect(o3.fmbase_format_type).to eq "ZD"
      end

      let(:o4) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Numérico com vírgula") }
      it "equal Numérico com vírgula" do
        expect(o4.fmbase_format_type).to eq "ZD"
      end

      let(:o5) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Compactado com vírgula") }
      it "equal Compactado com vírgula" do
        expect(o5.fmbase_format_type).to eq "PD"
      end

      let(:o6) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "Binário Mainframe") }
      it "equal Binário Mainframe" do
        expect(o6.fmbase_format_type).to eq "BI"
      end

      let(:o7) { FactoryGirl.create(:origin_field, cd5_variable_number: 555, data_type: "-----") }
      it "equal Binário Mainframe" do
        expect(o7.fmbase_format_type).to eq nil
      end
    end
  end
end
