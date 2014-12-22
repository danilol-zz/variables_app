require 'rails_helper'

describe ExportScript do
	script_ref = '

	insert into controle_bigdata.tah6_regr_arqu_cerf values ( “CD5.RETR.B<Origem.[Mnemônico]>” , "<Origem.[Nome da base/arquivo]>" , "T" , “CD5.RETR.B<Origem.[Mnemônico]>” , “” , “CD5P<Origem.[Mnemônico]>" , "" , "" , "" , "N" , "N" , "N" , "NORMAL" , "NORMAL" , "NORMAL" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" );
	'

	script_ref2 = '
	<Campos de Origem.[Núm var cd5]>|4|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|55|H|<Campos de Origem.[Formato origem CD5]>|<Campos de Origem.[Tam.]>|<Campos de Origem.[Decimal]>|55|S|<Origem.[Cód. origem CD5]>|<Campos de Origem.[Posição]>|<Campos de Origem.[Tam.]>|<Campos de Origem.[Formato origem CD5]>|<Campos de Origem.[Decimal]>|55|R||Não se aplica|Não se aplica|Seleção H|<Campos de Origem.[Desc. form. origem cd5 (Tipo Dado)]>|N/A|Semanal|<Origem.[Nome origem CD5]>|Repositório de Dados|<Campos de Origem.[Desc. form. origem cd5 (Tipo Dado)]>|N/A||N|
	'

	script_ref3 = "
\#!/usr/bin/ksh
set -x -a
. /PROD/INCLUDE/include.prod
echo \"\\n`date +%d/%m/%y_%H:%M:%S`\\n\"
DATE=`date +%d%m%y_%H%M%S`
/PROD/PGMS/DSTAGE_CORP.SH <Tabela.[@nome_data_stage_espelho]> > ${DIRLOG}/<Tabela.[@nome_data_stage_espelho]>.${DATE} 2>&1 
codret=$?
cat $DIRLOG/<Tabela.[@nome_data_stage_espelho]>.${DATE}
exit $codret

"
	script_ref4 =  '
insert into controle_bigdata.tah6_pro values (“CD5P<Origem.[Mnemônico]>”,”<Origem.[Nome da base/arquivo]>”,”<Origem.[@periodicidade_origem_mysql]>”,”2014-12-23”);
'

	condition = "<Campos de Origem.[Vai usar?=SIM]>"


	script_mini = "<Processo.[Nome da rotina]>.SQL 
	<Processo.[Nome tabela var]>"

	script_mini2 = '

use crm_origens;

drop TABLE <Origem.[Nome tabela hive]>

CREATE EXTERNAL TABLE <Origem.[Nome tabela hive]>

(

 <Campos de Origem.[@lista_de_campos]>

 FILLER STRING

)


	'

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
		before do
			@dic = ExportScript.make_dictionary
		end

		it "should return error if list is invalid" do
			list = Hash.new
			expect(ExportScript.translate_list(list,@dic)).to eq nil

			list = nil
			expect(ExportScript.translate_list(list,@dic)).to eq nil

			list=""
			expect(ExportScript.translate_list(list,@dic)).to eq nil

			list={"Processo" => nil }
			expect(ExportScript.translate_list(list,@dic)).to eq nil

			list={"Processo" => "" }
			expect(ExportScript.translate_list(list,@dic)).to eq nil

			list={"Processo" => [] }
			expect(ExportScript.translate_list(list,@dic)).to eq nil
		end

		it "should return error if dont find a entity" do
			list = Hash.new
			list["Processo_Erro"] = ["Nome programa"]
			expect(ExportScript.translate_list(list,@dic)).to eq nil
		end

		it "should return erro if dont find a attribute" do
			list = Hash.new
			list["Processo"] = ["Nome programa erro"]
			expect(ExportScript.translate_list(list,@dic)).to eq nil
		end

		it "should execute sucessfull" do
			str=script_mini
			list = ExportScript.get_list_entits(str)
			list_trans = ExportScript.translate_list(list,@dic)
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
			
			sprint = nil
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil

			sprint = 10
			entity = nil
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil

			sprint = ''
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil

			sprint = 10
			entity = 10
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil

			sprint = 0
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil

			sprint = 10
			entity = ""
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil
		end

		it 'should return erro if the entity is invalid' do
			sprint = 10
			entity = "Table_Erro"
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil
		end

		it 'should return erro if the sprint dont exists' do
			
			sprint = 1111
			entity = "Table"
			expect(ExportScript.get_entits_by_sprint(sprint,entity,nil)).to eq nil
		end

		it 'should return sucessfull Origin' do
			sprint = 1
			entity = "Origin"
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["mnemonic"]).to eq "L001"

		end
		it 'should return sucessfull OriginField' do
			sprint = 1
			entity = "OriginField"
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
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
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["communication_channel"]).to eq "CRE300"
		end

		it 'should return sucessfull variable' do
			sprint = 1
			entity = "Variable"
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 1
			expect(result[0]["name"]).to eq "Indicador Elegibilidade"
		end

		it 'should return sucessfull Processid' do
			sprint = 1
			entity = "Processid"
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			
			expect(result.size).to eq 1
			
			expect(result[0]["id"]).to eq 1
			expect(result[0]["process_number"]).to eq 1

			sprint = 2
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			
			expect(result.size).to eq 1
			
			expect(result[0]["id"]).to eq 1
			expect(result[0]["process_number"]).to eq 1
		end


		it 'should return sucessfull Table' do
			sprint = 10
			entity = "Table"
			result=ExportScript.get_entits_by_sprint(sprint,entity,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]["updated_in_sprint"]).to eq 10
			expect(result[0]["routine_number"]).to eq 1
		end
	end





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
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)).to eq nil

			entity_ref=@org
			name_entity_to_find=nil
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)).to eq nil

			entity_ref=""
			name_entity_to_find="OriginField"
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)).to eq nil

			entity_ref=@org
			name_entity_to_find=""
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)).to eq nil

		end

		it 'should return erro if entity dont have relationship' do
			entity_ref=@org
			name_entity_to_find="Table"
			expect(ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)).to eq nil
		end

		it 'should sucessfull execution ' do
			entity_ref=@org
			name_entity_to_find="OriginField"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			expect(result[0]).to be_kind_of(OriginField)
			expect(result[0]["field_name"]).to eq "CPF"
			expect(result[1]["field_name"]).to eq "LIMIT"

			entity_ref=@of1
			name_entity_to_find="Origin"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]).to be_kind_of(Origin)
			expect(result[0]["mnemonic"]).to eq "L001"


			entity_ref=@var2
			name_entity_to_find="OriginField"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
			expect(result[0]).to be_kind_of(OriginField)
			expect(result[0]["field_name"]).to eq "LIMIT"

			entity_ref=@tb
			name_entity_to_find="Variable"
			result=ExportScript.get_entits_related(entity_ref,name_entity_to_find,nil)
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			expect(result[0]).to be_kind_of(Variable)
			expect(result[0]["name"]).to eq "Indicador Elegibilidade"
			expect(result[1]["name"]).to eq "Indicador Elegibilidade Funcionario"
			
		end

	end

	context '.generate_script_by_sprint' do
		before do
			FactoryGirl.create(:user, id: 1  )
			FactoryGirl.create(:origin , id:1, updated_in_sprint:1 , periodicity: "diaria", mnemonic:"L001"  , file_name:"L0.BASE.ALP01" )
			FactoryGirl.create(:origin , id:2, updated_in_sprint:1 , periodicity: "mensal", mnemonic:"CC01"  , file_name:"CD5.BASE.FCC0I" )

			FactoryGirl.create(:origin_field, id:1, origin_id:1, will_use: "SIM", field_name: "CPF"  )
			FactoryGirl.create(:origin_field, id:2, origin_id:1, will_use: "NÃO", field_name: "LIMIT")

			FactoryGirl.create(:origin_field, id:3, origin_id:2, will_use: "SIM", field_name: "AGENCIA"  )
			FactoryGirl.create(:origin_field, id:4, origin_id:2, will_use: "NÃO", field_name: "CONTA"    )

			FactoryGirl.create(:table , id: 1 , mirror_table_number: 225 , updated_in_sprint: 1 , mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE")
		end
		
		it "should return sucessfull with one entity" do
			
			result = ExportScript.generate_script_by_sprint(1, script_ref, "Origem", false, nil) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2
			expect(result[0].include?("L001") ).to eq true
			expect(result[0].include?("L0.BASE.ALP01") ).to eq true
			expect(result[1].include?("CC01" ) ).to eq true
			expect(result[1].include?("CD5.BASE.FCC0I") ).to eq true
			
		end

		it "should return sucessfull with more than one entity" do
			result = ExportScript.generate_script_by_sprint(1, script_ref2, "Campos de Origem", false, nil) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 4

			expect(result[0].include? "CPF" ).to eq true
			expect(result[1].include? "LIMIT" ).to eq true

			expect(result[2].include? "AGENCIA" ).to eq true
			expect(result[3].include? "CONTA" ).to eq true

		end

		it "should return sucessfull with more than one entity and with condition" do
			result = ExportScript.generate_script_by_sprint(1, script_ref2, "Campos de Origem", false, condition) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2

			expect(result[0].include? "CPF" ).to eq true


			expect(result[1].include? "AGENCIA" ).to eq true


		end

		it "should return sucessful with function for one entity" do
		
			result = ExportScript.generate_script_by_sprint(1, script_ref3, "Tabela", false, nil) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 1
		
			expect(result[0].include? "CD5_225_carga_tabela_csld_ramo_ccre_esp" ).to eq true
		
		end

		it "should return sucessful with function for one entity" do

			result = ExportScript.generate_script_by_sprint(1, script_ref4, "Origem", false, nil) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2

			expect(result[0].include? '”D”' ).to eq true
			expect(result[1].include? '”M”' ).to eq true

		end

		it "should return sucessfull with more than one entity and with condition and function to agregate" do
			result = ExportScript.generate_script_by_sprint(1, script_mini2, "Origem", true, condition) 
			
			expect(result).to be_kind_of(Array)
			expect(result.size).to eq 2

			expect(result[0].include? "CPF" ).to eq true
			expect(result[1].include? "AGENCIA" ).to eq true


		end
		
	end


	context 'functions for ExportScript' do
		before do
			FactoryGirl.create(:user, id: 1  )
			@tb = FactoryGirl.create(:table , id: 1   , mirror_table_number: 225 , final_table_number: 224 ,  mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", final_physical_table_name: "TBCD5224_CSLD_UTIZ_RAMO_CCRE" )

			@org1 = FactoryGirl.create(:origin , id:1  , periodicity: "diaria", mnemonic:"L001"  , file_name:"L0.BASE.ALP01" )
			@org2 = FactoryGirl.create(:origin , id:2  , periodicity: "mensal", mnemonic:"CC01"  , file_name:"CD5.BASE.FCC0I" )

			@org3 = FactoryGirl.create(:origin , id:3   )

			@of1 = FactoryGirl.create(:origin_field, id:1, origin_id:1, will_use: "SIM", field_name: "CPF"  )
			@of2 = FactoryGirl.create(:origin_field, id:2, origin_id:1, will_use: "NÃO", field_name: "LIMIT")

			@of3 = FactoryGirl.create(:origin_field, id:3, origin_id:2, will_use: "SIM", field_name: "AGENCIA"  )
			@of4 = FactoryGirl.create(:origin_field, id:4, origin_id:2, will_use: "NÃO", field_name: "CONTA"    )

			@of5  = FactoryGirl.create(:origin_field, id:5, origin_id:3, width:10, field_name: "CAMPO_TEXTO"                    , fmbase_format_datyp: "AN", has_signal: "NÃO", data_type: "alfanumerico"           , will_use: "NÃO", cd5_output_order: 1)
			@of6  = FactoryGirl.create(:origin_field, id:6, origin_id:3, width:10, field_name: "CAMPO_COMPACTDO"                , fmbase_format_datyp: "PD", has_signal: "NÃO", data_type: "compactado"             , will_use: "SIM", cd5_output_order: 2)
			@of7  = FactoryGirl.create(:origin_field, id:7, origin_id:3, width:10, field_name: "CAMPO_COMPACTDO_SINAL"          , fmbase_format_datyp: "PD", has_signal: "SIM", data_type: "compactado"             , will_use: "SIM", cd5_output_order: 3)
			@of8  = FactoryGirl.create(:origin_field, id:8, origin_id:3, width:10, field_name: "CAMPO_NUMERICO_VIRGULA"         , fmbase_format_datyp: "ZD", has_signal: "NÃO", data_type: "numerico com virgula"   , will_use: "SIM", cd5_output_order: 4)
			@of9  = FactoryGirl.create(:origin_field, id:9, origin_id:3, width:10, field_name: "CAMPO_COMPACTADO_VIRGULA_SINAL" , fmbase_format_datyp: "PD", has_signal: "SIM", data_type: "compactado com virgula" , will_use: "SIM", cd5_output_order: 5)

			@tb2 = FactoryGirl.create(:table      , id:2, key_fields_hive_script: "CPF string ," , table_type: "seleção")
			@pro = FactoryGirl.create(:processid    , id:1, process_number: 1)

			@var = FactoryGirl.create(:variable    , id:1,  name: "Indicador Elegibilidade",  model_field_name:"IND_ELEG", sas_update_periodicity: "semanal")

			@var2 = FactoryGirl.create(:variable    , id:2, name: "Indicador Elegibilidade Funcionario",  model_field_name: "IND_ELEG_FUNC", sas_update_periodicity: "diária")

			@pro.variables << [@var, @var2]	
			@tb2.variables << [@var, @var2]

		end


		it ".nome_data_stage: should return erro with invalid parm" do

			tb=nil
			expect(ExportScript.nome_data_stage(tb,"espelho")).to eq nil

			tb=""
			expect(ExportScript.nome_data_stage(tb,"espelho")).to eq nil

			tb=nil
			expect(ExportScript.nome_data_stage(tb,"espelho")).to eq nil

			tb=""
			expect(ExportScript.nome_data_stage(tb,"espelho")).to eq nil

			tb=nil
			expect(ExportScript.nome_data_stage(tb,"definitivo")).to eq nil

			tb=""
			expect(ExportScript.nome_data_stage(tb,"definitivo")).to eq nil

			tb=nil
			expect(ExportScript.nome_data_stage(tb,"definitivo")).to eq nil

			tb=""
			expect(ExportScript.nome_data_stage(tb,"definitivo")).to eq nil

			tb=@tb
			expect(ExportScript.nome_data_stage(tb,nil)).to eq nil

			tb=@tb
			expect(ExportScript.nome_data_stage(tb,"parm_invalido")).to eq nil
		

		end

		it ".nome_data_stage: should sucessfull execute" do
			#TBCD5225_ESPL_CSLD_RAMO_CCRE
			#TBCD5224_CSLD_UTIZ_RAMO_CCRE
			tb=@tb
			result=ExportScript.nome_data_stage(tb,"espelho")
			expect(result).to be_kind_of(String)
			expect(result).to eq "CD5_225_carga_tabela_csld_ramo_ccre_esp"

			tb=@tb
			result=ExportScript.nome_data_stage(tb,"definitivo")
			expect(result).to be_kind_of(String)
			expect(result).to eq "CD5_224_carga_tabela_csld_utiz_ramo_ccre_def"

		end

		it ".periodicidade_origem: should return with invalid parm" do
			org =nil
			expect(ExportScript.periodicidade(org,"mysql")).to eq nil

			org=""
			expect(ExportScript.periodicidade(org,"mysql")).to eq nil

			org=@org1
			expect(ExportScript.periodicidade(org,nil)).to eq nil

			org=@org1
			expect(ExportScript.periodicidade(org,"invalid")).to eq nil			


		end

		it ".periodicidade_origem: should return sucessfull" do
			org=@org1
			result=ExportScript.periodicidade(org,"mysql")
			expect(result).to be_kind_of(String)
			expect(result).to eq "D"

			result=ExportScript.periodicidade(org,"particao")
			expect(result).to be_kind_of(String)
			expect(result).to eq "anomesdia"

			org=@org2
			result=ExportScript.periodicidade(org,"mysql")
			expect(result).to be_kind_of(String)
			expect(result).to eq "M"

			result=ExportScript.periodicidade(org,"particao")
			expect(result).to be_kind_of(String)
			expect(result).to eq "anomes"


			tb=@tb2
			result=ExportScript.periodicidade(tb,"smap")
			expect(result).to be_kind_of(String)
			expect(result).to eq "diária"

			pro=@pro
			result=ExportScript.periodicidade(pro,"smap")
			expect(result).to be_kind_of(String)
			expect(result).to eq "diária"


		end

		it ".lista_de_campos: should return invalid parm" do
			array_of = nil
			expect(ExportScript.lista_de_campos(array_of)).to eq nil

			array_of = ""
			expect(ExportScript.lista_de_campos(array_of)).to eq nil

			array_of = []
			expect(ExportScript.lista_de_campos(array_of)).to eq nil

			array_of = [""]
			expect(ExportScript.lista_de_campos(array_of)).to eq nil


		end

		it ".lista_de_campos: should sucessfull" do
			array_of = @org1.origin_fields.to_a
			result = ExportScript.lista_de_campos(array_of)
			expect(result).to be_kind_of(String)
			expect(result.split("\n").size).to eq 3
			expect(result.include?("CPF")).to eq true
			expect(result.include?("LIMIT")).to eq true

		end

		it ".tamanho_expandido: should return erro by invalid parm" do
			of = nil
			expect(ExportScript.tamanho_expandido(of)).to eq nil
			
			of = ""
			expect(ExportScript.tamanho_expandido(of)).to eq nil
		end

		it ".tamanho_expandido: should return sucessfull" do
			of = @of5
			result = ExportScript.tamanho_expandido(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "10"

			of = @of6
			result = ExportScript.tamanho_expandido(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "10"

			of = @of7
			result = ExportScript.tamanho_expandido(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "11"

			of = @of8
			result = ExportScript.tamanho_expandido(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "11"

			of = @of9
			result = ExportScript.tamanho_expandido(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "12"
		end

		it ".expressao_regular: should return invalid parm" do
			array_of = nil
			expect(ExportScript.expressao_regular(array_of)).to eq nil

			array_of = ""
			expect(ExportScript.expressao_regular(array_of)).to eq nil

			array_of = []
			expect(ExportScript.expressao_regular(array_of)).to eq nil

			array_of = [""]
			expect(ExportScript.expressao_regular(array_of)).to eq nil


		end

		it ".expressao_regular: should sucessfull" do
			array_of = @org3.origin_fields.to_a
			result = ExportScript.expressao_regular(array_of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "(.{0,10})(.{0,11})(.{0,11})(.{0,12})(.{0,1343})"

		end

		it ".chave_hive: should return error invalid parm" do
			pro = nil
			expect(ExportScript.chave_hive(pro)).to eq nil

			pro = ""
			expect(ExportScript.chave_hive(pro)).to eq nil
		end
		it ".chave_hive should return error entity without relationship" do
			pro = FactoryGirl.create(:processid, id:666)
			expect(ExportScript.chave_hive(pro)).to eq nil
			var = FactoryGirl.create(:variable, id:666) 
			expect(ExportScript.chave_hive(pro)).to eq nil

		end

		it ".chave_hive: should return sucessfull" do
			pro = @pro
			result = ExportScript.chave_hive(pro)
			expect(result).to be_kind_of(String)
			expect(result).to eq "CPF string ,"
		end

		it ".campos_modelo: should return erro invalid parm" do
			pro = nil
			expect(ExportScript.campos_modelo(pro)).to eq nil

			pro = ""
			expect(ExportScript.campos_modelo(pro)).to eq nil

		end

		it ".campos_modelo should return erro entity without relationship" do
			pro = FactoryGirl.create(:processid, id:667) 
			expect(ExportScript.campos_modelo(pro)).to eq nil
		end

		it ".campos_modelo: should return sucessfull" do
			pro = @pro
			result = ExportScript.campos_modelo(pro)
			expect(result).to be_kind_of(String)
			expect(result.include?("IND_ELEG")).to eq true
			expect(result.include?("IND_ELEG_FUNC")).to eq true
		end

		it ".posicao_saida: should return erro by invalid parm" do
			of = nil
			expect(ExportScript.posicao_saida(of)).to eq nil
			
			of = ""
			expect(ExportScript.posicao_saida(of)).to eq nil

			of = @of5
			result = ExportScript.posicao_saida(of)
			expect(result).to eq nil
		end

		it ".posicao_saida: should return sucessfull" do

			of = @of6
			result = ExportScript.posicao_saida(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "1"

			of = @of7
			result = ExportScript.posicao_saida(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "11"

			of = @of8
			result = ExportScript.posicao_saida(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "22"

			of = @of9
			result = ExportScript.posicao_saida(of)
			expect(result).to be_kind_of(String)
			expect(result).to eq "33"


		end
	end

	context '.export_script_by_sprint' do
		before do
			FactoryGirl.create(:user, id: 1  )
			@org1 = FactoryGirl.create(:origin , id:1  , updated_in_sprint:1, periodicity: "diaria", mnemonic:"L001"  , file_name:"L0.BASE.ALP01" )
			@org2 = FactoryGirl.create(:origin , id:2  , updated_in_sprint:1, periodicity: "mensal", mnemonic:"CC01"  , file_name:"CD5.BASE.FCC0I" )
		end
		it 'should work' do
			list=ExportScript.get_list_scritps
			expect(list).to be_kind_of(Array)
			expect(list.size > 0).to eq true

			array_script = ExportScript.export_script_by_sprint(1,"Script MySql Cadastro de Arquivo")
			expect(array_script).to be_kind_of(String)
			expect(array_script.split("\n").size > 5).to eq true 

		end
	end

	context 'test full' do
		before do
			FactoryGirl.create(:user, id: 1  )
			
			@cm = FactoryGirl.create(:campaign    , id:1, updated_in_sprint:1 , communication_channel: "CRE300")

			@tb = FactoryGirl.create(:table , id: 1   , mirror_table_number: 225 , final_table_number: 224 ,  mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", final_physical_table_name: "TBCD5224_CSLD_UTIZ_RAMO_CCRE" )

			@org1 = FactoryGirl.create(:origin , cd5_portal_origin_code: 100, id:1  , updated_in_sprint:2, periodicity: "diaria", mnemonic:"L001"  , file_name:"L0.BASE.ALP01" )
			@org2 = FactoryGirl.create(:origin , cd5_portal_origin_code: 111, id:2  , updated_in_sprint:2, periodicity: "mensal", mnemonic:"CC01"  , file_name:"CD5.BASE.FCC0I" )

			@org3 = FactoryGirl.create(:origin , cd5_portal_origin_code: 222, id:3 , updated_in_sprint:1, periodicity: "mensal", mnemonic:"TT"  , file_name:"TT5.BASE.TESTE01"   )

			@of1 = FactoryGirl.create(:origin_field, id:1, origin_id:1, will_use: "SIM", field_name: "CPF"  )
			@of2 = FactoryGirl.create(:origin_field, id:2, origin_id:1, will_use: "NÃO", field_name: "LIMIT")

			@of3 = FactoryGirl.create(:origin_field, id:3, origin_id:2, will_use: "SIM", field_name: "AGENCIA"  )
			@of4 = FactoryGirl.create(:origin_field, id:4, origin_id:2, will_use: "NÃO", field_name: "CONTA"    )

			@of5  = FactoryGirl.create(:origin_field, id:5, origin_id:3, width:10, field_name: "CAMPO_TEXTO"                    , fmbase_format_datyp: "AN", has_signal: "NÃO", data_type: "alfanumerico"           , will_use: "NÃO", cd5_output_order: 1)
			@of6  = FactoryGirl.create(:origin_field, id:6, origin_id:3, width:10, field_name: "CAMPO_COMPACTDO"                , fmbase_format_datyp: "PD", has_signal: "NÃO", data_type: "compactado"             , will_use: "SIM", cd5_output_order: 2)
			@of7  = FactoryGirl.create(:origin_field, id:7, origin_id:3, width:10, field_name: "CAMPO_COMPACTDO_SINAL"          , fmbase_format_datyp: "PD", has_signal: "SIM", data_type: "compactado"             , will_use: "SIM", cd5_output_order: 3)
			@of8  = FactoryGirl.create(:origin_field, id:8, origin_id:3, width:10, field_name: "CAMPO_NUMERICO_VIRGULA"         , fmbase_format_datyp: "ZD", has_signal: "NÃO", data_type: "numerico com virgula"   , will_use: "SIM", cd5_output_order: 4)
			@of9  = FactoryGirl.create(:origin_field, id:9, origin_id:3, width:10, field_name: "CAMPO_COMPACTADO_VIRGULA_SINAL" , fmbase_format_datyp: "PD", has_signal: "SIM", data_type: "compactado com virgula" , will_use: "SIM", cd5_output_order: 5)

			@tb2 = FactoryGirl.create(:table      , id:2, key_fields_hive_script: "CPF string ," , table_type: "seleção")
			@pro = FactoryGirl.create(:processid    , id:1, process_number: 1)

			@var = FactoryGirl.create(:variable    ,  updated_in_sprint:1 , id:1,  name: "Indicador Elegibilidade",  model_field_name:"IND_ELEG", sas_update_periodicity: "semanal")

			@var2 = FactoryGirl.create(:variable    ,  updated_in_sprint:1, id:2, name: "Indicador Elegibilidade Funcionario",  model_field_name: "IND_ELEG_FUNC", sas_update_periodicity: "diária")

			@pro.variables << [@var, @var2]	
			@tb2.variables << [@var, @var2]
			@cm.variables << [@var, @var2]
			@var.origin_fields << [@of5, @of6, @of7]
			@var2.origin_fields << [@of8, @of9]
		end

		it "should work " do
			list_scripts = ExportScript.get_list_scritps
			expect(list_scripts).to be_kind_of(Array)
			expect(list_scripts.size > 0).to eq true

			list_scripts.each do |script|
				ExportScript.export_script_by_sprint(1,script)
			end
			#ExportScript.export_script_by_sprint(1,"Smap Rotina Mainframe Extrator")


		end
	end
end
