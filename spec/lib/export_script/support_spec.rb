require 'rails_helper'

describe Support do
  context '.make_dictionary' do
    before do
      @dic = Generator.make_dictionary
    end

    it "should return error if list is invalid" do
      list = Hash.new
      expect(Generator.translate_list(list,@dic)).to eq nil

      list = nil
      expect(Generator.translate_list(list,@dic)).to eq nil

      list=""
      expect(Generator.translate_list(list,@dic)).to eq nil

      list={"Processo" => nil }
      expect(Generator.translate_list(list,@dic)).to eq nil

      list={"Processo" => "" }
      expect(Generator.translate_list(list,@dic)).to eq nil

      list={"Processo" => [] }
      expect(Generator.translate_list(list,@dic)).to eq nil
    end

    it "should return error if dont find a entity" do
      list = Hash.new
      list["Processo_Erro"] = ["Nome programa"]
      expect(Generator.translate_list(list,@dic)).to eq nil
    end

    it "should return erro if dont find a attribute" do
      list = Hash.new
      list["Processo"] = ["Nome programa erro"]
      expect(Generator.translate_list(list,@dic)).to eq nil
    end

    it "should execute sucessfull" do
      script_mini = "<Processo.[Nome da rotina]>.SQL
        <Processo.[Nome tabela var]>"

      str=script_mini
      list = Generator.get_entities_list(str)
      list_trans = Generator.translate_list(list,@dic)
      expect(list_trans).to be_kind_of(Hash)
      expect(list_trans.size).to eq 1
      expect(list_trans.has_key?("Processid")).to eq true
      expect(list_trans["Processid"].size).to eq 2
      expect(list_trans["Processid"][0]).to eq "routine_name"
      expect(list_trans["Processid"][1]).to eq "var_table_name"
    end
  end
end
