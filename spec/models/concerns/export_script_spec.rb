require 'rails_helper'

script_ref = '

#!/usr/bin/ksh
set -x -a
. /PROD/INCLUDE/include.prod
echo "\n`date +%d/%m/%y_%H:%M:%S`\n "
$DIREXE/bigdata_exec_proc.sh <Tabela.[Nome rotina big data]> <Tabela.[Nome rotina big data]>.SQL


'
script_mini = "<Processo.[Nome da rotina]>.SQL 
<Processo.[Nome tabela var]>"

describe ExportScript do

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


# comentado para dar commit, depois voltar para continuar

=begin
	context '.get_entits_by_sprint' do

		
		it 'should return erro if the parms is invalid' do
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
			FactoryGirl.create(:table, updated_in_sprint: 10 )
			sprint = 10
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil
		end

		it 'should return erro if the sprint dont exists' do
			FactoryGirl.create(:table, updated_in_sprint: 10 )
			sprint = 1111
			entity = "Table"
			expect(ExportScript.get_entits_by_sprint(sprint,entity)).to eq nil
		end

		it 'should return sucessfull' do
			FactoryGirl.create(:table, updated_in_sprint: 10 )
			sprint = 10
			entity = "Table"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["sprint"]).to eq 1
			expect(reject[0]["id"]).to 1
			expect(reject[0]["big_data_routine_name"]).to "CD5PT002"
		end

	end
=end
end
