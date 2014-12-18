require 'rails_helper'

describe ExportScript do
script_ref = '

insert into controle_bigdata.tah6_regr_arqu_cerf values ( “CD5.RETR.B<Origem.[mnmonico]>” , "<Origem.[nome da base / arquivo]>" , "T" , “CD5.RETR.B<Origem.[mnmonico]>” , “” , “CD5P<Origem.[mnmonico]>" , "" , "" , "" , "N" , "N" , "N" , "NORMAL" , "NORMAL" , "NORMAL" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" );
'
script_mini = "<Processo.[Nome da rotina]>.SQL 
<Processo.[Nome tabela var]>"
	context '.get_list_entits' do

		it "should return error script empty" do
			str=""
			expect(ExportScript.get_list_entits(str)).to eq nil
		end

		it "should return erro without dint find any entit" do
			str="string sem valor"
			expect(ExportScript.get_list_entits(str)).to eq nil
		end

		it "should get sucess with simple exemplo" do
			str=script_mini
			result = ExportScript.get_list_entits(str)
			expect(result).to be_kind_of(Hash)
			expect(result.size).to eq 1
			expect(result.has_key?("Processo")).to eq true
			expect(result["Processo"].size).to eq 2
			expect(result["Processo"][0]).to eq "Nome da rotina"
			expect(result["Processo"][1]).to eq "Nome tabela var"
		end

	end

	context '.translate_list' do

		it "should return error if list is invalid" do
			list = Hash.new
			expect(ExportScript.translate_list(list)).to eq nil

			list = nil
			expect(ExportScript.translate_list(list)).to eq nil

			list=""
			expect(ExportScript.translate_list(list)).to eq nil

			list={"Processo" => nil }
			expect(ExportScript.translate_list(list)).to eq nil

			list={"Processo" => "" }
			expect(ExportScript.translate_list(list)).to eq nil

			list={"Processo" => [] }
			expect(ExportScript.translate_list(list)).to eq nil
		end

		it "should return error if dont find a entity" do
			list = Hash.new
			list["Processo_Erro"] = ["Nome programa"]
			expect(ExportScript.translate_list(list)).to eq nil
		end

		it "should return erro if dont find a attribute" do
			list = Hash.new
			list["Processo"] = ["Nome programa erro"]
			expect(ExportScript.translate_list(list)).to eq nil
		end

		it "should execute sucessfull" do
			str=script_mini
			list = ExportScript.get_list_entits(str)
			list_trans = ExportScript.translate_list(list)
			expect(list_trans).to be_kind_of(Hash)
			expect(list_trans.size).to eq 1
			expect(list_trans.has_key?("Processid")).to eq true
			expect(list_trans["Processid"].size).to eq 2
			expect(list_trans["Processid"][0]).to eq "routine_name"
			expect(list_trans["Processid"][1]).to eq "var_table_name"
		end

	end


	context '.get_entits_by_sprint' do
		before do
			FactoryGirl.create(:user, id: 1  )
			FactoryGirl.create(:origin      , id:1, updated_in_sprint:1 , mnemonic: "L001"   )
			
			FactoryGirl.create(:origin_field, id:1, origin_id: 1        , field_name: "CPF"  )
			FactoryGirl.create(:origin_field, id:2, origin_id:1         , field_name: "LIMIT")
			
			FactoryGirl.create(:campaign    , id:1, updated_in_sprint:1 , communication_channel: "CRE300")

			FactoryGirl.create(:variable    , id:1, updated_in_sprint:1 , name: "Indicador Elegibilidade")



		end
=begin		
		it 'should return erro if the parms is invalid' do
			#let(:tb) {FactoryGirl.create(:table, updated_in_sprint: 10 , big_data_routine_name: "CD5PT002" )}
			sprint = nil
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil

			sprint = 10
			entity = nil
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil

			sprint = ''
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil

			sprint = 10
			entity = 10
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil

			sprint = 0
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil

			sprint = 10
			entity = ""
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil
		end

		it 'should return erro if the entity is invalid' do
			#FactoryGirl.create(:table, updated_in_sprint: 10 , big_data_routine_name: "CD5PT002" )
			sprint = 10
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil
		end

		it 'should return erro if the sprint dont exists' do
			
			sprint = 1111
			entity = "Table"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil
		end
=end
		it 'should return sucessfull Origin' do
			#FactoryGirl.create(:table, updated_in_sprint: 10 , big_data_routine_name: "CD5PT002" )
			sprint = 1
			entity = "Origin"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["mnemonic"]).to eq "L001"

		end
		it 'should return sucessfull OriginField' do
			sprint = 1
			entity = "OriginField"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			
			expect(result.size).to eq 2
			
			expect(result[0]["id"]).to eq 1
			expect(result[0]["field_name"]).to eq "CPF"

			expect(result[1]["id"]).to eq 2
			expect(result[1]["field_name"]).to eq "LIMIT"
		end

		it 'should return sucessfull Campaign' do
			sprint = 1
			entity = "Campaign"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["communication_channel"]).to eq "CRE300"
		end

		it 'should return sucessfull variable' do
			sprint = 1
			entity = "Variable"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["name"]).to eq "Indicador Elegibilidade"
		end

	end

end
