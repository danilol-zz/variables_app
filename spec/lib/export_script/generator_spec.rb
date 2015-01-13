require 'rails_helper'

describe Generator do
  let(:current_user_id) { FactoryGirl.create(:user, id: 1) }
  let(:script_mysql_name) { "Script MySql Cadastro de Arquivo" }
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

  #condition = "<Campos de Origem.[Vai usar?=true]>"


  script_mini2 = '

use crm_origens;

drop TABLE <Origem.[Nome tabela hive]>

CREATE EXTERNAL TABLE <Origem.[Nome tabela hive]>

(

 <Campos de Origem.[@lista_de_campos]>

 FILLER STRING

)


  '

  context '.get_entities_list' do
    subject { Generator.get_entities_list(entity_param) }

    context "with nil value" do
      let(:entity_param) { nil }

      it "should return error script empty" do
        expect(subject).to eq Hash.new
      end
    end

    context 'with invalid value' do
      let(:entity_param) { "" }

      it "should return error script empty" do
        expect(subject).to eq Hash.new
      end
    end

    context 'with valid value' do
      context 'with wrong script' do
        let(:entity_param) { "string sem valor" }

        it "returns an empty hash" do
          expect(subject).to eq Hash.new
        end
      end

      context "with valid script" do
        let(:entity_param) { "<Processo.[Nome da rotina]>.SQL <Processo.[Nome tabela var]>" }

        it "should get sucess with simple example" do
          expect(subject.size).to eq 1
          expect(subject.has_key?("Processo")).to eq true
          expect(subject["Processo"].size).to eq 2
          expect(subject["Processo"][0]).to eq "Nome da rotina"
          expect(subject["Processo"][1]).to eq "Nome tabela var"
        end
      end
    end
  end

  context '.get_campaign_by_sprint' do
    before do
      @campaign1 = FactoryGirl.create(:campaign, id: 1, updated_in_sprint: 1, communication_channel: "CRE300", current_user_id: current_user_id)
      @campaign2 = FactoryGirl.create(:campaign, id: 2, updated_in_sprint: 1, communication_channel: "CRE301", current_user_id: current_user_id)
      @campaign3 = FactoryGirl.create(:campaign, id: 3, updated_in_sprint: 2, communication_channel: "CRE302", current_user_id: current_user_id)
    end

    subject { Generator.get_campaign_by_sprint(sprint, condition) }

    context "with null values" do
      let(:sprint)    { nil }
      let(:condition) { nil }

      it "returns an empty array for nil sprint value" do
        expect(subject).to eq []
      end
    end

    context "with valid param" do
      context 'without condition param' do
        let(:sprint)    { 1 }
        let(:condition) { nil }

        it "returns two existing campaigns" do
          expect(subject).to eq [@campaign1, @campaign2]
        end
      end

      context 'with condition param' do
        context "when campaign is not found" do
          let(:sprint)    { 1 }
          let(:condition) { { communication_channel: "CRE302" } }

          it "returns an existing campaign" do
            expect(subject).to eq []
          end
        end

        context "when campaign is found" do
          let(:sprint)    { 1 }
          let(:condition) { { communication_channel: "CRE301" } }

          it "returns an existing campaign" do
            expect(subject).to eq [@campaign2]
          end
        end
      end
    end
  end

  context '.get_table_by_sprint' do
    before do
      @table1 = FactoryGirl.create(:table, id: 1, updated_in_sprint: 1, routine_number: 1, current_user_id: current_user_id)
      @table2 = FactoryGirl.create(:table, id: 2, updated_in_sprint: 1, routine_number: 2, current_user_id: current_user_id)
      @table3 = FactoryGirl.create(:table, id: 3, updated_in_sprint: 2, routine_number: 3, current_user_id: current_user_id)
    end

    subject { Generator.get_table_by_sprint(sprint, condition) }

    context "with null values" do
      let(:sprint)    { nil }
      let(:condition) { nil }

      it "returns an empty array for nil sprint value" do
        expect(subject).to eq []
      end
    end

    context "with valid param" do
      context 'without condition param' do
        let(:sprint)    { 1 }
        let(:condition) { nil }

        it "returns two existing tables" do
          expect(subject).to eq [@table1, @table2]
        end
      end

      context 'with condition param' do
        context "when table is not found" do
          let(:sprint)    { 1 }
          let(:condition) { "routine_number=3" }

          it "returns an existing table" do
            expect(subject).to eq []
          end
        end

        context "when table is found" do
          let(:sprint)    { 1 }
          let(:condition) { "routine_number=1" }

          it "returns an existing table" do
            expect(subject).to eq [@table1]
          end
        end
      end
    end
  end

  context '.get_origin_by_sprint' do
    before do
      @origin1 = FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, mnemonic: "L001", current_user_id: current_user_id)
      @origin2 = FactoryGirl.create(:origin, id: 2, updated_in_sprint: 1, mnemonic: "L002", current_user_id: current_user_id)
      @origin3 = FactoryGirl.create(:origin, id: 3, updated_in_sprint: 2, mnemonic: "L003", current_user_id: current_user_id)
    end

    subject { Generator.get_origin_by_sprint(sprint, condition) }

    context "with null values" do
      let(:sprint)    { nil }
      let(:condition) { nil }

      it "returns an empty array for nil sprint value" do
        expect(subject).to eq []
      end
    end

    context "with valid param" do
      context 'without condition param' do
        let(:sprint)    { 1 }
        let(:condition) { nil }

        it "returns two existing origins" do
          expect(subject).to eq [@origin1, @origin2]
        end
      end

      context 'with condition param' do
        context "when origin is not found" do
          let(:sprint)    { 1 }
          let(:condition) { { mnemonic: "L003" } }

          it "returns an existing origin" do
            expect(subject).to eq []
          end
        end

        context "when origin is found" do
          let(:sprint)    { 1 }
          let(:condition) { { mnemonic: "L001" } }

          it "returns an existing origin" do
            expect(subject).to eq [@origin1]
          end
        end
      end
    end
  end

  context '.get_variable_by_sprint' do
    before do
      @var1 = FactoryGirl.create(:variable, id: 1, updated_in_sprint: 1, name: "Indicador Elegibilidade", current_user_id: current_user_id)
      @var2 = FactoryGirl.create(:variable, id: 2, updated_in_sprint: 1, name: "Indicador Elegibilidade Funcionario", current_user_id: current_user_id)
      @var3 = FactoryGirl.create(:variable, id: 3, updated_in_sprint: 2, name: "Indicador Elegibilidade Teste", current_user_id: current_user_id)
    end

    subject { Generator.get_variable_by_sprint(sprint, condition) }

    context "with null values" do
      let(:sprint)    { nil }
      let(:condition) { nil }

      it "returns an empty array for nil sprint value" do
        expect(subject).to eq []
      end
    end

    context "with valid param" do
      context 'without condition param' do
        let(:sprint)    { 1 }
        let(:condition) { nil }

        it "returns two existing variables" do
          expect(subject).to eq [@var1, @var2]
        end
      end

      context 'with condition param' do
        context "when variable is not found" do
          let(:sprint)    { 1 }
          let(:condition) { "name=Indicador Elegibilidade Teste" }

          it "returns an existing variable" do
            expect(subject).to eq []
          end
        end

        context "when variable is found" do
          let(:sprint)    { 1 }
          let(:condition) { "name=Indicador Elegibilidade" }

          it "returns an existing variable" do
            expect(subject).to eq [@var1]
          end
        end
      end
    end
  end

  context '.get_origin_field_by_sprint' do
    before do
      @origin1       = FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, mnemonic: "L001", current_user_id: current_user_id)
      @origin2       = FactoryGirl.create(:origin, id: 2, updated_in_sprint: 2, mnemonic: "L002", current_user_id: current_user_id)
      @origin_field1 = FactoryGirl.create(:origin_field, id: 1, origin_id: 1, field_name: "CPF",  will_use:  true, current_user_id: current_user_id)
      @origin_field2 = FactoryGirl.create(:origin_field, id: 2, origin_id: 1, field_name: "CPF2", will_use: false, current_user_id: current_user_id)
      @origin_field3 = FactoryGirl.create(:origin_field, id: 3, origin_id: 2, field_name: "CPF3", will_use:  true, current_user_id: current_user_id)
      @origin_field4 = FactoryGirl.create(:origin_field, id: 4, origin_id: 2, field_name: "CPF4", will_use: false, current_user_id: current_user_id)
    end

    subject { Generator.get_origin_field_by_sprint(sprint, condition) }

    context "with null values" do
      let(:sprint)    { nil }
      let(:condition) { nil }

      it "returns an empty array for nil sprint value" do
        expect(subject).to eq []
      end
    end

    context "when origin doesnt exist" do
      let(:sprint)    { 5 }
      let(:condition) { nil }

      it "returns two existing origin fields" do
        expect(subject).to eq []
      end
    end

    context "with valid param" do
      context "when origin exists" do
        context 'without condition param' do
          let(:sprint)    { 1 }
          let(:condition) { nil }

          it "returns two existing origin fields" do
            expect(subject).to eq [@origin_field1, @origin_field2]
          end
        end

        context 'with condition param' do
          context "when origin field is not found" do
            let(:sprint)    { 4 }
            let(:condition) { { will_use: true } }

            it "returns an empty array" do
              expect(subject).to eq []
            end
          end

          context "when origin field is found" do
            let(:sprint)    { 2 }
            let(:condition) { { will_use: false } }

            it "returns an existing origin field" do
              expect(subject).to eq [@origin_field4]
            end
          end
        end
      end
    end
  end

  context '.get_entities_by_sprint' do
    before do
      FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, mnemonic: "L001", current_user_id: current_user_id)

      FactoryGirl.create(:origin_field, id: 1, origin_id: 1, field_name:   "CPF", current_user_id: current_user_id)
      FactoryGirl.create(:origin_field, id: 2, origin_id: 1, field_name: "LIMIT", current_user_id: current_user_id)

      FactoryGirl.create(:campaign, id: 1, updated_in_sprint: 1, communication_channel: "CRE300", current_user_id: current_user_id)

      var1 = FactoryGirl.create(:variable, id: 1, updated_in_sprint: 1, name: "Indicador Elegibilidade", current_user_id: current_user_id)
      var2 = FactoryGirl.create(:variable, id: 2, updated_in_sprint: 2, name: "Indicador Elegibilidade Funcionario", current_user_id: current_user_id)

      pro = FactoryGirl.create(:processid, id: 1, process_number: 1, current_user_id: current_user_id)
      pro.variables << [var1, var2]

      FactoryGirl.create(:table, id: 1, updated_in_sprint: 10, routine_number: 1, current_user_id: current_user_id)
    end

    it 'should return erro if the parms is invalid' do

      sprint = nil
      entity = "Table_Erro"
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil

      sprint = 10
      entity = nil
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil

      sprint = ''
      entity = "Table_Erro"
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil

      sprint = 10
      entity = 10
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil

      sprint = 0
      entity = "Table_Erro"
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil

      sprint = 10
      entity = ""
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil
    end

    it 'should return erro if the entity is invalid' do
      sprint = 10
      entity = "Table_Erro"
      expect(Generator.get_entities_by_sprint(sprint,entity,nil)).to eq nil
    end

    it 'should return erro if the sprint dont exists' do

      sprint = 1111
      entity = "Table"
      expect(Generator.get_entities_by_sprint(sprint, entity, nil)).to eq []
    end

    it 'should return sucessfull Origin' do
      sprint = 1
      entity = "Origin"
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]["updated_in_sprint"]).to eq 1
      expect(result[0]["mnemonic"]).to eq "L001"

    end
    it 'should return sucessfull OriginField' do
      sprint = 1
      entity = "OriginField"
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
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
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]["updated_in_sprint"]).to eq 1
      expect(result[0]["communication_channel"]).to eq "CRE300"
    end

    it 'should return sucessfull variable' do
      sprint = 1
      entity = "Variable"
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]["updated_in_sprint"]).to eq 1
      expect(result[0]["name"]).to eq "Indicador Elegibilidade"
    end

    it 'should return sucessfull Processid' do
      sprint = 1
      entity = "Processid"
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)

      expect(result.size).to eq 1

      expect(result[0]["id"]).to eq 1
      expect(result[0]["process_number"]).to eq "1"

      sprint = 2
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)

      expect(result.size).to eq 1

      expect(result[0]["id"]).to eq 1
      expect(result[0]["process_number"]).to eq "1"
    end


    it 'should return sucessfull Table' do
      sprint = 10
      entity = "Table"
      result=Generator.get_entities_by_sprint(sprint,entity,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]["updated_in_sprint"]).to eq 10
      expect(result[0]["routine_number"]).to eq 1
    end
  end





  context '.get_entities_related' do
    before do
      @org = FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, mnemonic: "L001", current_user_id: current_user_id)

      @of1 = FactoryGirl.create(:origin_field, id: 1, origin_id: 1, field_name:   "CPF", current_user_id: current_user_id)
      @of2 = FactoryGirl.create(:origin_field, id: 2, origin_id: 1, field_name: "LIMIT", current_user_id: current_user_id)

      @cp = FactoryGirl.create(:campaign, id: 1, updated_in_sprint: 1, communication_channel: "CRE300", current_user_id: current_user_id)

      @var1 = FactoryGirl.create(:variable, id: 1, updated_in_sprint: 1, name: "Indicador Elegibilidade", current_user_id: current_user_id)
      @var2 = FactoryGirl.create(:variable, id: 2, updated_in_sprint: 2, name: "Indicador Elegibilidade Funcionario", current_user_id: current_user_id)

      @pro = FactoryGirl.create(:processid, id: 1, process_number: 1, current_user_id: current_user_id)

      @tb = FactoryGirl.create(:table, id: 1, updated_in_sprint: 10, routine_number: 1, current_user_id: current_user_id)

      @tb.variables  << [@var1, @var2]
      @pro.variables << [@var1, @var2]
      @cp.variables  << [@var1, @var2]

      @var1.origin_fields << [@of1]
      @var2.origin_fields << [@of2]
    end

    it 'should return erro if parm invalid' do
      entity_ref=nil
      name_entity_to_find="OriginField"
      expect(Generator.get_entities_related(entity_ref,name_entity_to_find,nil)).to eq nil

      entity_ref=@org
      name_entity_to_find=nil
      expect(Generator.get_entities_related(entity_ref,name_entity_to_find,nil)).to eq nil

      entity_ref=""
      name_entity_to_find="OriginField"
      expect(Generator.get_entities_related(entity_ref,name_entity_to_find,nil)).to eq nil

      entity_ref=@org
      name_entity_to_find=""
      expect(Generator.get_entities_related(entity_ref,name_entity_to_find,nil)).to eq nil

    end

    it 'should return erro if entity dont have relationship' do
      entity_ref=@org
      name_entity_to_find="Table"
      expect(Generator.get_entities_related(entity_ref,name_entity_to_find,nil)).to eq nil
    end

    it 'should sucessfull execution ' do
      entity_ref=@org
      name_entity_to_find="OriginField"
      result=Generator.get_entities_related(entity_ref,name_entity_to_find,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 2
      expect(result[0]).to be_kind_of(OriginField)
      expect(result[0]["field_name"]).to eq "CPF"
      expect(result[1]["field_name"]).to eq "LIMIT"

      entity_ref=@of1
      name_entity_to_find="Origin"
      result=Generator.get_entities_related(entity_ref,name_entity_to_find,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]).to be_kind_of(Origin)
      expect(result[0]["mnemonic"]).to eq "L001"


      entity_ref=@var2
      name_entity_to_find="OriginField"
      result=Generator.get_entities_related(entity_ref,name_entity_to_find,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 1
      expect(result[0]).to be_kind_of(OriginField)
      expect(result[0]["field_name"]).to eq "LIMIT"

      entity_ref=@tb
      name_entity_to_find="Variable"
      result=Generator.get_entities_related(entity_ref,name_entity_to_find,nil)
      expect(result).to be_kind_of(Array)
      expect(result.size).to eq 2
      expect(result[0]).to be_kind_of(Variable)
      expect(result[0]["name"]).to eq "Indicador Elegibilidade"
      expect(result[1]["name"]).to eq "Indicador Elegibilidade Funcionario"

    end

  end

  context '.generate_script_by_sprint' do
    before do
      FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, periodicity: "diaria", mnemonic: "L001", file_name: "L0.BASE.ALP01", current_user_id: current_user_id )
      FactoryGirl.create(:origin, id: 2, updated_in_sprint: 1, periodicity: "mensal", mnemonic: "CC01", file_name: "CD5.BASE.FCC0I", current_user_id: current_user_id )

      FactoryGirl.create(:origin_field, id: 1, origin_id: 1, will_use:  true, field_name:   "CPF", current_user_id: current_user_id  )
      FactoryGirl.create(:origin_field, id: 2, origin_id: 1, will_use: false, field_name: "LIMIT", current_user_id: current_user_id)

      FactoryGirl.create(:origin_field, id: 3, origin_id: 2, will_use:  true, field_name: "AGENCIA", current_user_id: current_user_id  )
      FactoryGirl.create(:origin_field, id: 4, origin_id: 2, will_use: false, field_name: "  CONTA", current_user_id: current_user_id    )

      FactoryGirl.create(:table, id: 1, mirror_table_number: 225, updated_in_sprint: 1, mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", table_type: 'seleção', current_user_id: current_user_id)
    end

    subject { Generator.generate_script_by_sprint(1, script_name)}

    context "cadastro qualidade de arquivo" do
      let(:script_name) { "Script MySql Cadastro Qualidade de Arquivo" }

      it "should return sucessfull with one entity" do
        expect(subject).to be_kind_of(Array)
        expect(subject.size).to eq 2
        expect(subject[0].include?("L001") ).to eq true
        expect(subject[0].include?("L0.BASE.ALP01") ).to eq true
        expect(subject[1].include?("CC01" ) ).to eq true
        expect(subject[1].include?("CD5.BASE.FCC0I") ).to eq true
      end
    end

    context "integração cd5" do
      let(:script_name) { "Integração CD5 Cadastro de Campo de Entrada" }

      xit "should return sucessfull with more than one entity" do
        expect(subject).to be_kind_of(Array)
        expect(subject.size).to eq 4

        expect(subject[0].include? "CPF" ).to eq true
        expect(subject[1].include? "LIMIT" ).to eq true

        expect(subject[2].include? "AGENCIA" ).to eq true
        expect(subject[3].include? "CONTA" ).to eq true
      end
    end


    context "unix data stage espelho" do
      let(:script_name) { "script Unix Data Stage Espelho Rotina PE" }

      xit "should return sucessful with function for one entity" do
        expect(subject).to be_kind_of(Array)
        expect(subject.size).to eq 1
        expect(subject[0].include? "CD5_225_carga_tabela_csld_ramo_ccre_esp" ).to eq true
      end
    end

    context "cadstro de processo de arquivo" do
      let(:script_name) { "script MySql Cadastro de Processo de Arquivo" }

      it "should return sucessful with function for one entity" do
        expect(subject).to be_kind_of(Array)
        expect(subject.size).to eq 2

        expect(subject[0].include? '”D”' ).to eq true
        expect(subject[1].include? '”M”' ).to eq true
      end
    end

    context "script Hive tablea ORG" do
      let(:script_name) { "script Hive Tabela ORG" }

      it "should return sucessfull with more than one entity and with condition and function to agregate" do
        expect(subject).to be_kind_of(Array)
        expect(subject.size).to eq 2

        expect(subject[0].include? "CPF" ).to eq true
        expect(subject[1].include? "AGENCIA" ).to eq true
      end
    end
  end

  context 'functions for Generator' do
    before do
      @tb  = FactoryGirl.create(:table, id: 1, mirror_table_number: 225, final_table_number: 224, mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", final_physical_table_name: "TBCD5224_CSLD_UTIZ_RAMO_CCRE", current_user_id: current_user_id)
      @tb2 = FactoryGirl.create(:table, id: 2, key_fields_hive_script: "CPF string ,", table_type: "seleção", current_user_id: current_user_id)

      @org1 = FactoryGirl.create(:origin, id: 1, periodicity: "diaria", mnemonic:"L001", file_name: "L0.BASE.ALP01", current_user_id: current_user_id)
      @org2 = FactoryGirl.create(:origin, id: 2, periodicity: "mensal", mnemonic:"CC01", file_name: "CD5.BASE.FCC0I", current_user_id: current_user_id)

      @org3 = FactoryGirl.create(:origin, id: 3, current_user_id: current_user_id)

      @of1 = FactoryGirl.create(:origin_field, id: 1, origin_id: 1, will_use:  true, field_name:   "CPF", current_user_id: current_user_id)
      @of2 = FactoryGirl.create(:origin_field, id: 2, origin_id: 1, will_use: false, field_name: "LIMIT", current_user_id: current_user_id)

      @of3 = FactoryGirl.create(:origin_field, id: 3, origin_id: 2, will_use:  true, field_name: "AGENCIA", current_user_id: current_user_id)
      @of4 = FactoryGirl.create(:origin_field, id: 4, origin_id: 2, will_use: false, field_name:   "CONTA", current_user_id: current_user_id)

      @of5  = FactoryGirl.create(:origin_field, id: 5, origin_id: 3, width: 10, field_name: "CAMPO_TEXTO"                    , fmbase_format_datyp: "AN", has_signal: false, data_type: "alfanumerico"           , will_use: false, cd5_output_order: 1, current_user_id: current_user_id)
      @of6  = FactoryGirl.create(:origin_field, id: 6, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTDO"                , fmbase_format_datyp: "PD", has_signal: false, data_type: "compactado"             , will_use:  true, cd5_output_order: 2, current_user_id: current_user_id)
      @of7  = FactoryGirl.create(:origin_field, id: 7, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTDO_SINAL"          , fmbase_format_datyp: "PD", has_signal:  true, data_type: "compactado"             , will_use:  true, cd5_output_order: 3, current_user_id: current_user_id)
      @of8  = FactoryGirl.create(:origin_field, id: 8, origin_id: 3, width: 10, field_name: "CAMPO_NUMERICO_VIRGULA"         , fmbase_format_datyp: "ZD", has_signal: false, data_type: "numerico com virgula"   , will_use:  true, cd5_output_order: 4, current_user_id: current_user_id)
      @of9  = FactoryGirl.create(:origin_field, id: 9, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTADO_VIRGULA_SINAL" , fmbase_format_datyp: "PD", has_signal:  true, data_type: "compactado com virgula" , will_use:  true, cd5_output_order: 5, current_user_id: current_user_id)

      @pro = FactoryGirl.create(:processid, id: 1, process_number: 1, current_user_id: current_user_id)

      @var1 = FactoryGirl.create(:variable, id: 1, name: "Indicador Elegibilidade",              model_field_name: "IND_ELEG",      sas_update_periodicity: "semanal", current_user_id: current_user_id)
      @var2 = FactoryGirl.create(:variable, id: 2, name: "Indicador Elegibilidade Funcionario",  model_field_name: "IND_ELEG_FUNC", sas_update_periodicity: "diária",  current_user_id: current_user_id)

      @pro.variables << [@var1, @var2]
      @tb2.variables << [@var1, @var2]
    end


    it ".nome_data_stage: should return erro with invalid parm" do

      tb=nil
      expect(Generator.nome_data_stage(tb,"espelho")).to eq nil

      tb=""
      expect(Generator.nome_data_stage(tb,"espelho")).to eq nil

      tb=nil
      expect(Generator.nome_data_stage(tb,"espelho")).to eq nil

      tb=""
      expect(Generator.nome_data_stage(tb,"espelho")).to eq nil

      tb=nil
      expect(Generator.nome_data_stage(tb,"definitivo")).to eq nil

      tb=""
      expect(Generator.nome_data_stage(tb,"definitivo")).to eq nil

      tb=nil
      expect(Generator.nome_data_stage(tb,"definitivo")).to eq nil

      tb=""
      expect(Generator.nome_data_stage(tb,"definitivo")).to eq nil

      tb=@tb
      expect(Generator.nome_data_stage(tb,nil)).to eq nil

      tb=@tb
      expect(Generator.nome_data_stage(tb,"parm_invalido")).to eq nil


    end

    it ".nome_data_stage: should sucessfull execute" do
      #TBCD5225_ESPL_CSLD_RAMO_CCRE
      #TBCD5224_CSLD_UTIZ_RAMO_CCRE
      tb=@tb
      result=Generator.nome_data_stage(tb,"espelho")
      expect(result).to be_kind_of(String)
      expect(result).to eq "CD5_225_carga_tabela_csld_ramo_ccre_esp"

      tb=@tb
      result=Generator.nome_data_stage(tb,"definitivo")
      expect(result).to be_kind_of(String)
      expect(result).to eq "CD5_224_carga_tabela_csld_utiz_ramo_ccre_def"

    end

    it ".periodicidade_origem: should return with invalid parm" do
      org =nil
      expect(Generator.periodicidade(org,"mysql")).to eq nil

      org=""
      expect(Generator.periodicidade(org,"mysql")).to eq nil

      org=@org1
      expect(Generator.periodicidade(org,nil)).to eq nil

      org=@org1
      expect(Generator.periodicidade(org,"invalid")).to eq nil


    end

    it ".periodicidade_origem: should return sucessfull" do
      org=@org1
      result=Generator.periodicidade(org,"mysql")
      expect(result).to be_kind_of(String)
      expect(result).to eq "D"

      result=Generator.periodicidade(org,"particao")
      expect(result).to be_kind_of(String)
      expect(result).to eq "anomesdia"

      org=@org2
      result=Generator.periodicidade(org,"mysql")
      expect(result).to be_kind_of(String)
      expect(result).to eq "M"

      result=Generator.periodicidade(org,"particao")
      expect(result).to be_kind_of(String)
      expect(result).to eq "anomes"


      tb=@tb2
      result=Generator.periodicidade(tb,"smap")
      expect(result).to be_kind_of(String)
      expect(result).to eq "diária"

      pro=@pro
      result=Generator.periodicidade(pro,"smap")
      expect(result).to be_kind_of(String)
      expect(result).to eq "diária"


    end

    it ".lista_de_campos: should return invalid parm" do
      array_of = nil
      expect(Generator.lista_de_campos(array_of)).to eq nil

      array_of = ""
      expect(Generator.lista_de_campos(array_of)).to eq nil

      array_of = []
      expect(Generator.lista_de_campos(array_of)).to eq nil

      array_of = [""]
      expect(Generator.lista_de_campos(array_of)).to eq nil


    end

    it ".lista_de_campos: should sucessfull" do
      array_of = @org1.origin_fields.to_a
      result = Generator.lista_de_campos(array_of)
      expect(result).to be_kind_of(String)
      expect(result.split("\n").size).to eq 3
      expect(result.include?("CPF")).to eq true
      expect(result.include?("LIMIT")).to eq true
    end

    it ".tamanho_expandido: should return erro by invalid parm" do
      of = nil
      expect(Generator.tamanho_expandido(of)).to eq nil

      of = ""
      expect(Generator.tamanho_expandido(of)).to eq nil
    end

    it ".tamanho_expandido: should return sucessfull" do
      of = @of5
      result = Generator.tamanho_expandido(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "10"

      of = @of6
      result = Generator.tamanho_expandido(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "10"

      of = @of7
      result = Generator.tamanho_expandido(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "11"

      of = @of8
      result = Generator.tamanho_expandido(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "11"

      of = @of9
      result = Generator.tamanho_expandido(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "12"
    end

    it ".expressao_regular: should return invalid parm" do
      array_of = nil
      expect(Generator.expressao_regular(array_of)).to eq nil

      array_of = ""
      expect(Generator.expressao_regular(array_of)).to eq nil

      array_of = []
      expect(Generator.expressao_regular(array_of)).to eq nil

      array_of = [""]
      expect(Generator.expressao_regular(array_of)).to eq nil


    end

    it ".expressao_regular: should sucessfull" do
      array_of = @org3.origin_fields.to_a
      result = Generator.expressao_regular(array_of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "(.{0,10})(.{0,11})(.{0,11})(.{0,12})(.{0,1343})"

    end

    it ".chave_hive: should return error invalid parm" do
      pro = nil
      expect(Generator.chave_hive(pro)).to eq nil

      pro = ""
      expect(Generator.chave_hive(pro)).to eq nil
    end
    it ".chave_hive should return error entity without relationship" do
      pro = FactoryGirl.create(:processid, id: 666, current_user_id: current_user_id)
      expect(Generator.chave_hive(pro)).to eq nil
      var = FactoryGirl.create(:variable, id: 666, current_user_id: current_user_id)
      expect(Generator.chave_hive(pro)).to eq nil

    end

    it ".chave_hive: should return sucessfull" do
      pro = @pro
      result = Generator.chave_hive(pro)
      expect(result).to be_kind_of(String)
      expect(result).to eq "CPF string ,"
    end

    it ".campos_modelo: should return erro invalid parm" do
      pro = nil
      expect(Generator.campos_modelo(pro)).to eq nil

      pro = ""
      expect(Generator.campos_modelo(pro)).to eq nil

    end

    it ".campos_modelo should return erro entity without relationship" do
      pro = FactoryGirl.create(:processid, id: 667, current_user_id: current_user_id)
      expect(Generator.campos_modelo(pro)).to eq nil
    end

    it ".campos_modelo: should return sucessfull" do
      pro = @pro
      result = Generator.campos_modelo(pro)
      expect(result).to be_kind_of(String)
      expect(result.include?("IND_ELEG")).to eq true
      expect(result.include?("IND_ELEG_FUNC")).to eq true
    end

    it ".posicao_saida: should return erro by invalid parm" do
      of = nil
      expect(Generator.posicao_saida(of)).to eq nil

      of = ""
      expect(Generator.posicao_saida(of)).to eq nil

      of = @of5
      result = Generator.posicao_saida(of)
      expect(result).to eq nil
    end

    it ".posicao_saida: should return sucessfull" do

      of = @of6
      result = Generator.posicao_saida(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "1"

      of = @of7
      result = Generator.posicao_saida(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "11"

      of = @of8
      result = Generator.posicao_saida(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "22"

      of = @of9
      result = Generator.posicao_saida(of)
      expect(result).to be_kind_of(String)
      expect(result).to eq "33"


    end
  end

  context '.export_script_by_sprint' do

    before do
      @org1 = FactoryGirl.create(:origin, id: 1, updated_in_sprint: 1, periodicity: "diaria", mnemonic:"L001", file_name: "L0.BASE.ALP01", current_user_id: current_user_id)
      @org2 = FactoryGirl.create(:origin, id: 2, updated_in_sprint: 1, periodicity: "mensal", mnemonic:"CC01", file_name: "CD5.BASE.FCC0I", current_user_id: current_user_id)
    end
    it 'should work' do
      #list=Generator.get_list_scripts
      #expect(list).to be_kind_of(Array)
      #expect(list.size > 0).to eq true
      array_script = Generator.export_script_by_sprint(1, script_mysql_name)
      expect(array_script).to be_kind_of(String)
      expect(array_script.split("\n").size > 5).to eq true

    end
  end

  context 'test full' do
    before do
      @cm = FactoryGirl.create(:campaign, id: 1, updated_in_sprint: 1, communication_channel: "CRE300", current_user_id: current_user_id)

      @tb  = FactoryGirl.create(:table, id: 1, mirror_table_number: 225, final_table_number: 224, mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", final_physical_table_name: "TBCD5224_CSLD_UTIZ_RAMO_CCRE", current_user_id: current_user_id)
      @tb2 = FactoryGirl.create(:table, id: 2, key_fields_hive_script: "CPF string ,", table_type: "seleção", current_user_id: current_user_id)

      @org1 = FactoryGirl.create(:origin, cd5_portal_origin_code: 100, id: 1, updated_in_sprint: 2, periodicity: "diaria", mnemonic:"L001", file_name:"L0.BASE.ALP01", current_user_id: current_user_id)
      @org2 = FactoryGirl.create(:origin, cd5_portal_origin_code: 111, id: 2, updated_in_sprint: 2, periodicity: "mensal", mnemonic:"CC01", file_name:"CD5.BASE.FCC0I", current_user_id: current_user_id)

      @org3 = FactoryGirl.create(:origin, cd5_portal_origin_code: 222, id: 3, updated_in_sprint: 1, periodicity: "mensal", mnemonic:"TT", file_name:"TT5.BASE.TESTE01", current_user_id: current_user_id)

      @of1 = FactoryGirl.create(:origin_field, id: 1, origin_id: 1, will_use:  true, field_name:     "CPF", current_user_id: current_user_id)
      @of2 = FactoryGirl.create(:origin_field, id: 2, origin_id: 1, will_use: false, field_name:   "LIMIT", current_user_id: current_user_id)
      @of3 = FactoryGirl.create(:origin_field, id: 3, origin_id: 2, will_use:  true, field_name: "AGENCIA", current_user_id: current_user_id)
      @of4 = FactoryGirl.create(:origin_field, id: 4, origin_id: 2, will_use: false, field_name:   "CONTA", current_user_id: current_user_id)
      @of5 = FactoryGirl.create(:origin_field, id: 5, origin_id: 3, width: 10, field_name: "CAMPO_TEXTO"                    , fmbase_format_datyp: "AN", has_signal: false, data_type: "alfanumerico"           , will_use: false, cd5_output_order: 1, current_user_id: current_user_id)
      @of6 = FactoryGirl.create(:origin_field, id: 6, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTDO"                , fmbase_format_datyp: "PD", has_signal: false, data_type: "compactado"             , will_use: true, cd5_output_order: 2, current_user_id: current_user_id)
      @of7 = FactoryGirl.create(:origin_field, id: 7, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTDO_SINAL"          , fmbase_format_datyp: "PD", has_signal: true, data_type: "compactado"             , will_use: true, cd5_output_order: 3, current_user_id: current_user_id)
      @of8 = FactoryGirl.create(:origin_field, id: 8, origin_id: 3, width: 10, field_name: "CAMPO_NUMERICO_VIRGULA"         , fmbase_format_datyp: "ZD", has_signal: false, data_type: "numerico com virgula"   , will_use: true, cd5_output_order: 4, current_user_id: current_user_id)
      @of9 = FactoryGirl.create(:origin_field, id: 9, origin_id: 3, width: 10, field_name: "CAMPO_COMPACTADO_VIRGULA_SINAL" , fmbase_format_datyp: "PD", has_signal: true, data_type: "compactado com virgula" , will_use: true, cd5_output_order: 5, current_user_id: current_user_id)

      @pro = FactoryGirl.create(:processid, id: 1, process_number: 1, current_user_id: current_user_id)

      @var  = FactoryGirl.create(:variable, updated_in_sprint: 1, id: 1, name: "Indicador Elegibilidade",             model_field_name:"IND_ELEG", sas_update_periodicity: "semanal", current_user_id: current_user_id)
      @var2 = FactoryGirl.create(:variable, updated_in_sprint: 1, id: 2, name: "Indicador Elegibilidade Funcionario", model_field_name: "IND_ELEG_FUNC", sas_update_periodicity: "diária", current_user_id: current_user_id)

      @pro.variables << [@var, @var2]
      @tb2.variables << [@var, @var2]
      @cm.variables << [@var, @var2]
      @var.origin_fields << [@of5, @of6, @of7]
      @var2.origin_fields << [@of8, @of9]
    end

    it "should work " do
      list_scripts = Support::HASH_SCRIPTS.keys
      expect(list_scripts).to be_kind_of(Array)
      expect(list_scripts.size > 0).to eq true

      #list_scripts.each do |script|
        #Generator.export_script_by_sprint(1,script)
      #end
    end
  end

  context '.translate_list' do
    let(:dic) { Support.make_dictionary }

    subject { Generator.translate_list(@list, dic) }

    context 'with invalid values' do
      it "returns nil when param is an empty hash" do
        @list = Hash.new
        expect(subject).to eq nil
      end

      it "returns nil when param is an nil" do
        @list = nil
        expect(subject).to eq nil
      end

      it "returns nil when param is an empty string" do
        @list = ""
        expect(subject).to eq nil
      end

      it "returns nil when param is a hash with nil value" do
        @list = {"Processo" => nil }
        expect(subject).to eq nil
      end

      it "returns nil when param is a hash with empty string value" do
        @list = {"Processo" => "" }
        expect(subject).to eq nil
      end

      it "returns nil when param is a hash with empty array value" do
        @list = {"Processo" => [] }
        expect(subject).to eq nil
      end
    end

    context 'with valid values' do
      context 'with wrong data' do
        it "returns nil if dont find a entity" do
          @list = { "Processo_Erro" => ["Nome programa"] }
          expect(subject).to eq nil
        end

        it "returns nil if dont find an attribute" do
          @list = { "processo" => ["nome programa erro"] }
          expect(subject).to eq nil
        end

        xit "returns nil if param type is wrong" do
          FactoryGirl.create(:table, id: 1, mirror_table_number: 225, updated_in_sprint: 1, mirror_physical_table_name: "TBCD5225_ESPL_CSLD_RAMO_CCRE", table_type: 'seleção', current_user_id: current_user_id)
          @list = {"Tabela"=>["Tipo=seleção"]}
          expect(subject).to eq nil
        end
      end

      context 'with correct data' do
        it "returns the translated list sucessfully" do
          @list = Generator.get_entities_list("<Processo.[Nome da rotina]>.SQL <Processo.[Nome tabela var]>")

          expect(subject.size).to eq 1
          expect(subject.has_key?("Processid")).to eq true
          expect(subject["Processid"].size).to eq 2
          expect(subject["Processid"][0]).to eq "routine_name"
          expect(subject["Processid"][1]).to eq "var_table_name"
        end
      end
    end
  end
end
