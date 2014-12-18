require 'rails_helper'

describe OriginField do
  context '.text_parser' do
    it "should return error when string is empty" do
      org_type="mainframe"
      origin_id=1
      str = ""
      expect(OriginField.text_parser(org_type,str, origin_id)).to eq nil
    end

    it "should return error when string is to small" do
      org_type="mainframe"
      origin_id=1
      str = "123"
      expect(OriginField.text_parser(org_type,str, origin_id)).to eq nil
    end

    it "should return error when string is name invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIP!                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str, origin_id)).to eq nil
    end

    it "should return error when string is origin_pic invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X 30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str, origin_id)).to eq nil
    end

    it "should return error when string is fmbase_format_type invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AP      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return error when string is start invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1A    30     30"
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end


    it "should return error when string is width invalid" do
      org_type="mainframe"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     3A"
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return erro when org_type is invalid" do
      org_type="arquivo"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return erro when more fields then expect" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return erro when less fields then expect" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref",""'
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return erro when invalid first field" do
      org_type="hadoop"
      origin_id=1
      str = '"dat@ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end



    it "should return error inverted type arquivo mainframe -> base hadoop" do
      org_type="mainframe"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

    it "should return error inverted type base hadoop -> arquivo mainframe" do
      org_type="hadoop"
      origin_id=1
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str,origin_id)).to eq nil
    end

   it "should save the object succesfully generic" do
      org_type="hadoop"
      origin_id=1
      str = '"dat_ref","dat_ref","","<Undefined>"'
      origin_field = OriginField.text_parser(org_type,str,origin_id)
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
      origin_field = OriginField.text_parser(org_type,str,origin_id)
      expect(origin_field).to be_kind_of(OriginField)

      expect(origin_field.field_name).to eq "TIPO"
      expect(origin_field.origin_pic).to eq "X(30)"
      expect(origin_field.data_type).to eq "alfanumerico"
      expect(origin_field.position).to eq 1
      expect(origin_field.width).to eq 30 
    end

  end
end
