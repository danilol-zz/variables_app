module Constants

  #geral
  STATUS = { SALA1: "sala1", SALA2: "sala2", PRODUCAO: "produção" }
  YES_NO = [ ["Sim", true], ["Não", false] ]

  #Origin
  #Origem: tipo de base, periodicidade,tipo de retenção dos dados
  base_type           =  ["Arquivo Mainframe", "Tabela Mainframe", "Base Hadoop", "Outro"]
  periodicity         =  ["Diária", "Semanal", "Quinzenal", "Mensal", "Anual", "Exporádica", "Outro"]
  data_retention_type =  ["Movimento do dia", "Apenas registros alterados", "Histórica", "Acumulado de um período"]
  extractor_file_type =  ["Novo", "Alterado"]
  dmt_classification  =  ["Atendido", "Pendente Revisão","Não atendido"]

  #OriginField
  #Campo de Origem: tipo de dado, formato fmbase,  tipo de dadp generico, CD5 formato origem, CD5 Descrição formato origem

  DATA_TYPES             = ["Alfanumérico", "Numérico", "Compactado", "Data", "Numérico com vírgula", "Compactado com Vírgula", "Binário Mainframe"]
  fmbase_format_type     = ["AN", "ZD", "PD", "BI"]
  generic_data_type      = ["texto", "numero", "data"]
  cd5_origin_format      = ["1" "2", "4", "2", "4", "6", "3"]
  cd5_origin_format_desc = ["character", "numeric", "Data"]
  mainframe_storage_type = ["Disco", "Fita"]

  #Variable
  #Variavel: tipo de dado, Periodicidade da atualização SAS, Tipo de Dominio, Status Modelo de Dados SAS, Status DRS da Variavel
  DATA_TYPE              = ["Qtd", "Data", "Valor", "Indicador", "Nome", "Código", "Porcentagem", "Número"]
  SAS_UPDATE_PERIODICITY = ["diária", "semanal", "quinzenal", "mensal", "anual", "exporádica", "outro"]
  DOMAIN_TYPE            = ["interno", "externo", "fixo" ]
  SAS_DATA_MODEL_STATUS  = ["Ok", "Pendente"]
  DRS_VARIABLE_STATUS    = ["Ok", "Pendente"]
  VARIABLE_TYPE          = ["calculado", "movimentação direta", "valor padrão"]

  #Campaign
  #Campanha: Status de Levantamento de critério de fábrica, Tipo de processo
  FACTORY_CRITERION_STATUS = ["Ok", "Pendente"]
  PROCESS_TYPE             = ["Automático", "DBM", "Gestor", "Manual"]

  #Table
  #Tabela: tipo de tabela
  TABLE_TYPE = ["seleção", "colagem", "lookup interna", "lookup externa", "lookup blindagem"]
end
