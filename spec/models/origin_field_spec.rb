require 'rails_helper'

describe OriginField do

  it { should respond_to :field_name }
  it { should respond_to :origin_pic }
  it { should respond_to :data_type }
  it { should respond_to :fmbase_format_type }
  it { should respond_to :generic_data_type }
  it { should respond_to :decimal }
  it { should respond_to :mask }
  it { should respond_to :position }
  it { should respond_to :width }
  it { should respond_to :is_key }
  it { should respond_to :will_use }
  it { should respond_to :has_signal }
  it { should respond_to :room_1_notes }
  it { should respond_to :cd5_variable_number}
  it { should respond_to :cd5_output_order}
  it { should respond_to :cd5_variable_name }
  it { should respond_to :cd5_origin_format }
  it { should respond_to :cd5_origin_format_desc }
  it { should respond_to :cd5_format }
  it { should respond_to :cd5_format_desc }
  it { should respond_to :default_value }
  it { should respond_to :room_2_notes }
  it { should respond_to :domain }
  it { should respond_to :dmt_notes }
  it { should respond_to :origin_id }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  it { should respond_to :origin_id }

  context '.text_parser' do
    it "should return error when string is empty" do
      org_type="arquivo mainframe"
      str = ""
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error when string is to small" do
      org_type="arquivo mainframe"
      str = "123"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error when string is name invalid" do
      org_type="arquivo mainframe"
      str = "  3   3 TIP!                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error when string is origin_pic invalid" do
      org_type="arquivo mainframe"
      str = "  3   3 TIPO                                  X 30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error when string is fmbase_format_type invalid" do
      org_type="arquivo mainframe"
      str = "  3   3 TIPO                                  X(30)     AP      1     30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error when string is start invalid" do
      org_type="arquivo mainframe"
      str = "  3   3 TIPO                                  X(30)     AN      1A    30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end


    it "should return error when string is width invalid" do
      org_type="arquivo mainframe"
      str = "  3   3 TIPO                                  X(30)     AN      1     30     3A"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return erro when org_type is invalid" do
      org_type="arquivo"
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return erro when more fields then expect" do
      org_type="base hadoop"
      str = '"dat_ref","dat_ref","","<Undefined>","<Undefined>"'
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return erro when less fields then expect" do
      org_type="base hadoop"
      str = '"dat_ref","dat_ref",""'
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return erro when invalid first field" do
      org_type="base hadoop"
      str = '"dat@ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end



    it "should return error inverted type arquivo mainframe -> base hadoop" do
      org_type="arquivo mainframe"
      str = '"dat_ref","dat_ref","","<Undefined>"'
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

    it "should return error inverted type base hadoop -> arquivo mainframe" do
      org_type="base hadoop"
      str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      expect(OriginField.text_parser(org_type,str)).to eq nil
    end

   it "should save the object succesfully generic" do
      org_type="base hadoop"
      str = '"dat_ref","dat_ref","","<Undefined>"'
      origin_field = OriginField.text_parser(org_type,str)
      expect(origin_field).to be_kind_of(OriginField)

      expect(origin_field.field_name).to eq "dat_ref"
      expect(origin_field.origin_pic).to eq "X(255)"
      expect(origin_field.data_type).to eq "alfanumerico"
      expect(origin_field.position).to eq 0
      expect(origin_field.width).to eq 0
    end

    it "should save the object succesfully mainframe" do
      org_type="arquivo mainframe"
      #str = "  3   3 TIPO                                  X(30)     AN      1     30     30"
      #str = " 40   3 FLAGNOFE                              9(01)     ZD     84     84      1"
      #str = " 13   3 CONTA                                           AN     23     29      7"
      #str = " 39   3 PERCINF                               S999V9(4) PD     80     83      4"
       str = "  6   3 DTREFR REDEFINES DTREF                9(08)     ZD     33     40      8"
      origin_field = OriginField.text_parser(org_type,str)
      expect(origin_field).to be_kind_of(OriginField)

      expect(origin_field.field_name).to eq "DTREFR"
      expect(origin_field.origin_pic).to eq "9(08)"
      expect(origin_field.data_type).to eq "numerico"
      expect(origin_field.position).to eq 33
      expect(origin_field.width).to eq 8
    end

  end
end
