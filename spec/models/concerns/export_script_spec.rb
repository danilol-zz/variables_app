require 'rails_helper'

describe ExportScript do
script_ref = '

insert into controle_bigdata.tah6_regr_arqu_cerf values ( “CD5.RETR.B<Origem.[Mnemônico]>” , "<Origem.[Nome da base/arquivo]>" , "T" , “CD5.RETR.B<Origem.[Mnemônico]>” , “” , “CD5P<Origem.[Mnemônico]>" , "" , "" , "" , "N" , "N" , "N" , "NORMAL" , "NORMAL" , "NORMAL" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" );
'
script_mini = "<Processo.[Nome da rotina]>.SQL 
<Processo.[Nome tabela var]>"
=begin
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

			var = FactoryGirl.create(:variable    , id:1, updated_in_sprint:1 , name: "Indicador Elegibilidade")

			var2 = FactoryGirl.create(:variable    , id:2, updated_in_sprint:2 , name: "Indicador Elegibilidade Funcionario")

			pro = FactoryGirl.create(:processid    , id:1,                       process_number: 1)

			pro.variables << [var, var2]			

			FactoryGirl.create(:table      , id:1, updated_in_sprint:10 , routine_number: 1   )



		end		
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

		it 'should return sucessfull Origin' do
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

		it 'should return sucessfull Processid' do
			sprint = 1
			entity = "Processid"
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			
			expect(result.size).to eq 1
			
			expect(result[0]["id"]).to eq 1
			expect(result[0]["process_number"]).to eq 1

			sprint = 2
			result=ExportScript.get_entits_by_sprint(sprint,entity)
			expect(result).to be_kind_of(Array)
			
			expect(result.size).to eq 1
			
			expect(result[0]["id"]).to eq 1
			expect(result[0]["process_number"]).to eq 1
		end


		#it 'should return sucessfull Table' do
		#	sprint = 10
		#	entity = "Table"
		#	result=ExportScript.get_entits_by_sprint(sprint,entity)
		#	expect(result).to be_kind_of(Array)
		#	expect(result.size).to eq 1
		#	expect(result[0]["updated_in_sprint"]).to eq 1
		#	expect(result[0]["routine_number"]).to eq 1
		#end
	end

=end

	context '.generate_script_by_sprint' do
		before do
			FactoryGirl.create(:user, id: 1  )
			FactoryGirl.create(:origin , id:1, updated_in_sprint:1 , mnemonic:"L001"  , file_name:"L0.BASE.ALP01" )
			FactoryGirl.create(:origin , id:2, updated_in_sprint:1 , mnemonic:"CC01"  , file_name:"CD5.BASE.FCC0I" )
		end
		
		it "should return sucessfull with one entity" do
			#expect( 
			result = ExportScript.generate_script_by_sprint(1, script_ref, "Origem") 
			#	).to be_kind_of(Array)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			#p result 
		end

		
		
	end


=begin
	context '.get_entits_related' do
		before do
			FactoryGirl.create(:user, id: 1  )
			@org = FactoryGirl.create(:origin      , id:1, updated_in_sprint:1 , mnemonic: "L001"   )
			
			@of1 = FactoryGirl.create(:origin_field, id:1, origin_id: 1        , field_name: "CPF"  )
			@of2 = FactoryGirl.create(:origin_field, id:2, origin_id:1         , field_name: "LIMIT")
			
			@cp = FactoryGirl.create(:campaign    , id:1, updated_in_sprint:1 , communication_channel: "CRE300")

			@var = FactoryGirl.create(:variable    , id:1, updated_in_sprint:1 , name: "Indicador Elegibilidade")

			@var2 = FactoryGirl.create(:variable    , id:2, updated_in_sprint:2 , name: "Indicador Elegibilidade Funcionario")

			@pro = FactoryGirl.create(:processid    , id:1,                       process_number: 1)

			@tb = FactoryGirl.create(:table      , id:1, updated_in_sprint:10 , routine_number: 1   )

			@tb.variables  << [@var, @var2]			
			@pro.variables << [@var, @var2]			
			@cp.variables  << [@var, @var2]			
			
			@var.origin_fields << [@of1]
			@var2.origin_fields << [@of2]

		end

		it 'should return erro if parm invalid' do
			
			entity_ref=nil
			name_entity_to_find="OriginField"
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find)).to eq nil

			entity_ref=@org
			name_entity_to_find=nil
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find)).to eq nil

			entity_ref=""
			name_entity_to_find="OriginField"
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find)).to eq nil

			entity_ref=@org
			name_entity_to_find=""
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find)).to eq nil

		end

		it 'should return erro if entity dont have relationship' do
			entity_ref=@org
			name_entity_to_find="Table"
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find)).to eq nil
		end

		it 'should sucessfull execution' do
			entity_ref=@org
			name_entity_to_find="OriginField"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			expect(result[0]).to be_kind_of(OriginField)
			expect(result[0]["field_name"]).to eq "CPF"
			expect(result[1]["field_name"]).to eq "LIMIT"

			entity_ref=@of1
			name_entity_to_find="Origin"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]).to be_kind_of(Origin)
			expect(result[0]["mnemonic"]).to eq "L001"


			entity_ref=@var2
			name_entity_to_find="OriginField"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]).to be_kind_of(OriginField)
			expect(result[0]["field_name"]).to eq "LIMIT"

			entity_ref=@tb
			name_entity_to_find="Variable"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			expect(result[0]).to be_kind_of(Variable)
			expect(result[0]["name"]).to eq "Indicador Elegibilidade"
			expect(result[1]["name"]).to eq "Indicador Elegibilidade Funcionario"
			





		end


	end
=end

end
