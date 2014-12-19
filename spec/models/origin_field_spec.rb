require 'rails_helper'

describe OriginField do
  let(:profile) { 'room1' }

  before do
    user = FactoryGirl.create(:user, profile: profile)

    subject.current_user_id = user.id
  end

  context '.text_parser' do
    it "should return error when string is empty" do
      org_type="mainframe"
      origin_id=1
      str = ""
      expect(OriginField.text_parser(org_type,str, origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error when string is to small" do
      org_type="mainframe"
      origin_id=1
      str = "123"
      expect(OriginField.text_parser(org_type,str, origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error when string is name invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIP!                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str, origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error when string is origin_pic invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X 30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str, origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error when string is fmbase_format_type invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AP      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error when string is start invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1A    30     30"
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end


    it "should return error when string is width invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     3A"
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return erro when org_type is invalid" do
      org_type="arquivo"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return erro when more fields then expect" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return erro when less fields then expect" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref",""'
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return erro when invalid first field" do
      org_type="hadoop"
      origin_id=1
      str = '"dat@ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end



    it "should return error inverted type arquivo mainframe -> base hadoop" do
      org_type="mainframe"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

    it "should return error inverted type base hadoop -> arquivo mainframe" do
      org_type="hadoop"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)).to eq nil
    end

   it "should save the object succesfully generic" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>"'
      origin_field = OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)
      expect(origin_field).to be_kind_of(OriginField)

      expect(origin_field.field_name).to eq "dat_ref"
      expect(origin_field.origin_pic).to eq "X(255)"
      expect(origin_field.data_type).to eq "alfanumerico"
      expect(origin_field.position).to eq 0
      expect(origin_field.width).to eq 0
    end

    it "should save the object succesfully mainframe" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      origin_field = OriginField.text_parser(org_type,str,origin_id, subject.current_user_id)
      expect(origin_field).to be_kind_of(OriginField)

      expect(origin_field.field_name).to eq "TIPO"
      expect(origin_field.origin_pic).to eq "X(30)"
      expect(origin_field.data_type).to eq "alfanumerico"
      expect(origin_field.position).to eq 1
      expect(origin_field.width).to eq 30 
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

