module Support

  def self.make_dictionary
    hash_transl = {
      "Campanha"         => { name_entity: Campaign.to_s, class_entity: Campaign, attribute_translated: Hash.new } ,
      "Origem"           => { name_entity: Origin.to_s, class_entity: Origin, attribute_translated: Hash.new } ,
      "Campos de Origem" => { name_entity: OriginField.to_s, class_entity: OriginField, attribute_translated: Hash.new } ,
      "Processo"         => { name_entity: Processid.to_s , class_entity: Processid , attribute_translated: Hash.new } ,
      "Tabela"           => { name_entity: Table.to_s, class_entity: Table, attribute_translated: Hash.new } ,
      "Variavel"         => { name_entity: Variable.to_s, class_entity: Variable, attribute_translated: Hash.new }
    }

    hash_transl.each_key do |entity|
      hash_transl[entity][:class_entity].attribute_names.each do |attribute_eng|
        attribute_br = hash_transl[entity][:class_entity].human_attribute_name(attribute_eng)
        hash_transl[entity][:attribute_translated][attribute_br] = attribute_eng
      end
    end

    hash_transl
  end

  REGEX = Regexp.new("<([A-Za-z\\ ]+)\\.\\[(.+?)\\]>", Regexp::MULTILINE)

  HASH_SCRIPTS = {
    "script Unix Rotina PV" => 	{
      "entity_master_br" => "Processo" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => "\#!/usr/bin/ksh
                  set -x -a
                  . /PROD/INCLUDE/include.prod
                  echo \"\\n`date +%d/%m/%y_%H:%M:%S`\\n \"
                  $DIREXE/cd5_executa_valida_variaveis.sh <Processo.[Nome da rotina]>.SQL <Processo.[Nome tabela var]> <Processo.[Regra de conferência]> <Processo.[Percentual de aceite]> <Processo.[Manter movimento anterior?]> <Processo.[Regra de contagem]>
                  codret=$?
                  exit $codret"
    } ,
    "script Unix Rotina PT" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => false ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => "\#!/usr/bin/ksh
                   set -x -a
                   . /PROD/INCLUDE/include.prod
                   echo \"\\n`date +%d/%m/%y_%H:%M:%S`\\n \"
                   $DIREXE/bigdata_exec_proc.sh <Tabela.[Nome rotina big data]> <Tabela.[Nome rotina big data]>.SQL

  "
    } ,
    "Script Unix Rotina PS" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => false ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => "hive -S -f /PROD/ODBS/<Tabela.[Nome rotina saida]>.SQL > /PROD/FILE/<Tabela.[Nome tabela fisica espelho]>.txt"
    } ,
    "Script Unix Ziptrans" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => false ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => "\#!/usr/bin/ksh
                  set -x -a
                  . /PROD/INCLUDE/include.prod
                  echo \"\\n`date +%d/%m/%y_%H:%M:%S`\\n \"
                  $DIREXE/ZYPTRAN03 VCIXP0055CTO /PROD/FILE/<Tabela.[Nome tabela fisica espelho]>.txt SCXX141CTO /PROD/FILE/<Tabela.[Nome tabela fisica espelho]>.txt"
    } ,
    "script Unix Data Stage Espelho Rotina PE" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => false ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => "\#!/usr/bin/ksh
                   set -x -a
                   . /PROD/INCLUDE/include.prod
                   echo \"\\n`date +%d/%m/%y_%H:%M:%S`\n\"
                   DATE=`date +%d%m%y_%H%M%S`
                   /PROD/PGMS/DSTAGE_CORP.SH <Tabela.[@nome_data_stage_espelho]> > ${DIRLOG}/<Tabela.[@nome_data_stage_espelho]>.${DATE} 2>&1
                   codret=$?
                   cat $DIRLOG/<Tabela.[@nome_data_stage_espelho]>.${DATE}
                   exit $codret"
    } ,
    "script Unix Data Stage Espelho Rotina PD" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => false ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => "\#!/usr/bin/ksh
                   set -x -a
                   . /PROD/INCLUDE/include.prod
                   echo \"\\n`date +%d/%m/%y_%H:%M:%S`\\n\"
                   DATE=`date +%d%m%y_%H%M%S`
                   /PROD/PGMS/DSTAGE_CORP.SH <Tabela.[@nome_data_stage_definitivo]> > ${DIRLOG}/<Tabela.[@nome_data_stage_definitivo]>.${DATE} 2>&1
                   codret=$?
                   cat $DIRLOG/<Tabela.[@nome_data_stage_definitivo]>.${DATE}
                   exit $codret"
    } ,
    "script Hive Tabela ORG" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => true ,
      "condition" => "<Campos de Origem.[Vai usar?=true]>" ,
      "script" => "use crm_origens;
                   drop TABLE <Origem.[Nome tabela hive]>

                   CREATE EXTERNAL TABLE <Origem.[Nome tabela hive]>
                   (
                     <Campos de Origem.[@lista_de_campos]>
                      FILLER   STRING
                   )
                   PARTITIONED BY (
                   <Origem.[@periodicidade_origem_particao]> INT)
                   ROW FORMAT SERDE 'org.apache.hadoop.hive.contrib.serde2.RegexSerDe'
                   WITH SERDEPROPERTIES (\"input.regex\" =
                   \"<Campos de Origem.[@expressao_regular]>\" )
                   STORED AS INPUTFORMAT \"com.hadoop.mapred.DeprecatedLzoTextInputFormat\"
                   OUTPUTFORMAT \"org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat\";"
    } ,
    "Script Hive Query PV Vazia" => {
      "entity_master_br" => "Processo" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "set hive.exec.compress.output=true;
                   set mapred.output.compression.type=BLOCK;
                   set io.seqfile.compression.type=BLOCK;
                   set mapred.output.compression.codec=org.apache.hadoop.io.compress.SnappyCodec;

                   use crm_variaveis;
                   drop table crm_variaveis.<Processo.[Nome tabela var]>;

                   create external table <Processo.[Nome tabela var]>
                    (
                    <Processo.[@chave_hive]>
                    <Processo.[@campos_modelo]>
                    )
                   STORED AS SEQUENCEFILE
                   LOCATION '/dados/crm/variaveis/<Processo.[Nome tabela var]>';"
    } ,
    "script MySql Cadastro de Processo de Arquivo" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => 'insert into controle_bigdata.tah6_pro values (“CD5P<Origem.[Mnemônico]>”,”<Origem.[Nome da base/arquivo]>”,”<Origem.[@periodicidade_origem_mysql]>”,”2014-12-23”);'
    } ,
    "Script MySql Cadastro de Arquivo" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => 'insert into controle_bigdata.tah6_arq values (“CD5.RETR.B<Origem.[Mnemônico]>”, “CD5.RETR.CTRB<Origem.[Mnemônico]>”,"crm_origem","<Origem.[Nome tabela hive]>", "/dados/crm/origem/<Origem.[Nome tabela hive]>" , ”<Origem.[@periodicidade_origem_mysql]>” , ”<Origem.[@periodicidade_origem_mysql]>” , ”1-5-7” , null ,"D","D","S");'
    } ,
    "Script MySql Cadastro Qualidade de Arquivo" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => 'insert into controle_bigdata.tah6_regr_arqu_cerf values ( “CD5.RETR.B<Origem.[Mnemônico]>” , "<Origem.[Nome da base/arquivo]>" , "T" , “CD5.RETR.B<Origem.[Mnemônico]>” , “” , “CD5P<Origem.[Mnemônico]>" , "" , "" , "" , "N" , "N" , "N" , "NORMAL" , "NORMAL" , "NORMAL" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" , "CONTROLE QUALIDADE" , "Sistema_CD5@correio.itau.com.br" );'
    } ,
    "Script MySql Cadastro Regra de Qualidade de Arquivo" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => 'insert into controle_bigdata.tah6_regr_camo_cerf values ("CD5.RETR.B<Origem.[Mnemônico]>","CD5.RETR.B<Origem.[Mnemônico]>","QTD",null,"N","N","N","N","N","N","N","N","V",-10.000,10.000,0,0,"NORMAL","CONTROLE QUALIDADE","Sistema_CD5@correio.itau.com.br");'
    } ,
    "Script MySql Cadastro de Processo de Calculo de Variavel - Rotina PV" => {
      "entity_master_br" => "Processo" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => 'insert into controle_bigdata.tah6_pro values (“<Processo.[Nome da rotina]>”,”<Processo.[Nome da rotina]>”,”<Processo.[@periodicidade_processo_mysql]>”,”2014-12-23”);'
    } ,
    "Script MySql Cadastro de Processo de Calculo de Tabela - Rotina PT" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => "<Tabela.[Tipo=seleção]>" ,
      "script" => 'insert into controle_bigdata.tah6_pro values (“<Tabela.[Nome rotina big data]>”,”<Tabela.[Nome rotina big data]>”,”<Tabela.[@periodicidade_tabela_mysql]>”,”2014-12-23”);'
    } ,
    "Integração CD5 Cadastro de Campo de Entrada" => {
      "entity_master_br" => "Campos de Origem" ,
      "ind_group_related" => false ,
      "condition" => "<Campos de Origem.[Vai usar?=true]>" ,
      "script" => "<Campos de Origem.[Núm var cd5]>|4|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|<Origem.[Cód. origem CD5]><Campos de Origem.[Nome do campo]>|55|H|<Campos de Origem.[Formato origem CD5]>|<Campos de Origem.[Tam.]>|<Campos de Origem.[Decimal]>|55|S|<Origem.[Cód. origem CD5]>|<Campos de Origem.[Posição]>|<Campos de Origem.[Tam.]>|<Campos de Origem.[Formato origem CD5]>|<Campos de Origem.[Decimal]>|55|R||Não se aplica|Não se aplica|Seleção H|<Campos de Origem.[Desc. form. origem cd5 (Tipo Dado)]>|N/A|Semanal|<Origem.[Nome origem CD5]>|Repositório de Dados|<Campos de Origem.[Desc. form. origem cd5 (Tipo Dado)]>|N/A||N|"
    } ,
    "Integração CD5 Cadastro de Campo de Saida" => {
      "entity_master_br" => "Campos de Origem" ,
      "ind_group_related" => false ,
      "condition" => "<Campos de Origem.[Vai usar?=true]>" ,
      "script" => '<Campos de Origem.[Núm var cd5]>| <Origem.[Cód. destino CD5]><Campos de Origem.[Nome do campo]>| <Origem.[Cód. destino CD5]>|<Campos de Origem.[Formato CD5]>|55|<Campos de Origem.[Formato CD5]>| <Campos de Origem.[@posicao_saida]>| <Campos de Origem.[@tamanho_expandido]>|<Campos de Origem.[Decimal]>|<Campos de Origem.[Descrição formato CD5]>|N/A|"<Campos de Origem.[Valor Padrao (Tipo Dado)]>"'
    } ,
    "Smap Rotina Mainframe Extrator" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => "Rotina Extratora:  CD5B<Origem.[Mnemônico]>
                   Step		Campo		Valor
                   CD5SRI40	SORTIN		<Origem.[Nome da base/arquivo]>
                   CD5SRI40	SORTOUT		CD5.BASE.O<Origem.[Mnemônico]>(0)
                   CD5BEX2A	PARM		<Origem.[Cód. origem CD5]>SB
                   CD5BEX2A	SYS010		CD5.BASE.O<Origem.[Mnemônico]>(+1)
                   CD5BEX2A	SYS024		CD5.WORK.B<Origem.[Mnemônico]>(+1)
                   CD5BEX2A	SYS040		CD5.BASE.QB<Origem.[Mnemônico]>(+1)
                   CD5SR18A	SORTIN		CD5.BASE.QB<Origem.[Mnemônico]>(+1)
                   CD5SR18A	SORTOUT		CD5.WORK.QB<Origem.[Mnemônico]>(+1)
                   ICEGENA	SYSUT1		CD5.WORK.B<Origem.[Mnemônico]>(+1)
                   ICEGENA	SYSUT1		CD5.WORK.Q<Origem.[Mnemônico]>(+1)
                   ICEGENA	SYSUT2		CD5.BASE.B<Origem.[Mnemônico]>(+1)"
    } ,
    "Smap Rotina Mainframe Roteador" => {
      "entity_master_br" => "Origem" ,
      "ind_group_related" => false ,
      "condition" => nil ,
      "script" => "Rotina de Roteamento: CD5R<Origem.[Mnemônico]>
                   Step		Campo	Valor
                   CD5BROTA	PARM	<Origem.[Cód. origem CD5]>
                   CD5BROTA	SYS011	CD5.BASE.Q<Origem.[Mnemônico]>(0)
                   ICEGENB	SYSUT1	CD5.BASE.B<Origem.[Mnemônico]>(0)
                   ICEGENC	SYSUT1	CD5.BASE.B<Origem.[Mnemônico]>(0)
                   ICEGEND	SYSUT1	CD5.BASE.B<Origem.[Mnemônico]>(0)
                   CD5BRO2A	PARM	<Origem.[Cód. origem CD5]>
                   CD5BRO2B	PARM	<Origem.[Cód. origem CD5]>
                   CD5BRO2C	PARM	<Origem.[Cód. origem CD5]>"
    } ,
    "Smap Rotina PV" => {
      "entity_master_br" => "Processo" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Campo		Valor
                   Nome da Rotina	<Processo.[Nome da rotina]>
                   Periodicidade	<Processo.[@periodicidade_processo_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista
                   Sucessora		Variavel.[@lista_de_rotinas_sucessoras]>"
    } ,
    "Smap Rotina PT" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Campo		Valor
                   Nome da Rotina	<Tabela.[Nome rotina big data]>
                   Periodicidade	<Tabela.[@periodicidade_tabela_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista
                   Sucessora		<Tabela.[Nome rotina saida]>"
    } ,
    "Smap Rotina PS" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Campo		Valor
                   Nome da Rotina	<Tabela.[Nome rotina saida]>
                   Periodicidade	<Tabela.[@periodicidade_tabela_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista
                   Sucessora		<Tabela.[Nome rotina ziptrans]>"
    } ,
    "Smap Rotina Ziptrans" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Campo		Valor
                   Nome da Rotina	<Tabela.[Nome rotina ziptrans]>
                   Periodicidade	<Tabela.[@periodicidade_tabela_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista
                   Sucessora	        <Tabela.[Nome rotina data stage espelho]>"
    } ,
    "Smap Rotina Data Stage Espelho" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Campo		Valor
                   Nome da Rotina	<Tabela.[Nome rotina data stage espelho]>
                   Periodicidade      	<Tabela.[@periodicidade_tabela_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista"
    } ,
    "Smap Rotina Data Stage Definitivo" => {
      "entity_master_br" => "Tabela" ,
      "ind_group_related" => true ,
      "condition" => nil ,
      "script" => "Nome da Rotina	<Tabela.[Nome rotina data stage difinitivo]>
                   Periodicidade        <Tabela.[@periodicidade_tabela_smap]>
                   Linha de negócio	crm-marketing
                   Area Afetada		marketing
                   SPPTI Planejamento	acionar analista"
    }
  }
end
