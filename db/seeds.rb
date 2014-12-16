# This file should contain all the record creation needed to seed the database with its default values.
require 'csv'

puts "####### deleting all users"
User.delete_all

puts "####### creating user 1"
User.create( :email => 'admin@admin.com', :name => 'administrador', :profile => Constants::STATUS[:SALA1], :password => 'admin', :role => 'admin' )

puts "####### creating user 2"
User.create( :email => 'danilo.moura.lima@gmail.com', :name => 'Danilo', :profile => Constants::STATUS[:SALA1], :password => '123456', :role => 'admin' )

puts "####### creating user 3"
User.create( :email => 'sergiosouzalima@gmail.com', :name => 'Sergio Lima 1', :profile => Constants::STATUS[:SALA1], :password => '123456', :role => 'admin' )

puts "####### creating user 4"
User.create( :email => 'sergiosouzalima@outlook.com', :name => 'Sergio Lima 2', :profile => Constants::STATUS[:SALA2], :password => '123456', :role => 'admin' )

puts ""

puts "####### deleting all process"
Processid.delete_all

CSV.read("db/fixtures/processo.csv", { headers: true, :col_sep => ","}).each_with_index do |campo, i|
  puts "####### creating process #{i + 1}"

  Processid.create(
    process_number: campo["numero processo"],
    mnemonic:  campo["mnmonico"],
    routine_name:  campo["nome rotina"],
    var_table_name:  campo["nome tabela var"],
    conference_rule:  campo["regra de conferencia"],
    acceptance_percent:  campo["percentual de aceite"],
    keep_previous_work:  campo["pode manter movimento anterior?"],
    counting_rule:  campo["regra de contagem"],
    notes:  campo["Observação"],
    status: Constants::STATUS[:SALA2] )
end

puts ""

puts "####### deleting all origins"
Origin.delete_all

CSV.read("db/fixtures/origem.csv", { headers: true, :col_sep => ","}).each_with_index do |campo, i|
  puts "####### creating origin #{i + 1}"

  Origin.create(
    file_name: campo["nome da base / arquivo"],
    file_description: campo["descrição da base"],
    created_in_sprint: campo["sprint em que foi criado"],
    updated_in_sprint: campo["sprint em que foi alterado"],
    abbreviation: campo["sigla"],
    base_type: campo["tipo de base"],
    book_mainframe: campo["book mainframe"],
    periodicity: campo[" periodicidade"],
    periodicity_details: campo["detalhe da periodicidade"],
    data_retention_type: campo["tipo de retenção dos dados"],
    extractor_file_type: campo["Característica do arquivo no Extrator"],
    room_1_notes: campo["observação - sala 1"],
    mnemonic:  campo["mnmonico"],
    cd5_portal_origin_code: campo["codigo origem portal cd5"],
    cd5_portal_origin_name: campo["nome origem portal cd5"],
    cd5_portal_destination_code: campo["codigo destino portal cd5"],
    cd5_portal_destination_name:campo["nome destino portal cd5"],
    hive_table_name: campo["nome tabela hive"],
    mainframe_storage_type: campo["tipo de armazenamento mainframe"],
    room_2_notes: campo["observação - sala 2"],
    status: Constants::STATUS[:SALA1]
    )
end

puts ""

puts "####### deleting all origin fields"
OriginField.delete_all

CSV.read("db/fixtures/campo de origem.csv", { headers: true, :col_sep => ","}).each_with_index do |campo, i|
  puts "####### creating origin field #{i + 1}"

  OriginField.create(
    field_name: campo["nome do campo"],
    origin_pic: campo["pic de origem"],
    data_type: campo["tipo de dado"],
    #fmbase_format_type: campo["tipo formato fmbase"],
    #generic_data_type: campo["tipo de dado generico"],
    decimal: campo["decimal"],
    mask: campo["mascara"],
    position: campo["posição"],
    width: campo["tamanho"],
    is_key: campo["é chave?"],
    will_use: campo["vai usar?"],
    has_signal: campo["tem sinal?"],
    room_1_notes: campo["observação sala 1"],
    #cd5_variable_number: campo["numero variavel cd5"],
    cd5_output_order: campo["ordem de saida CD5"],
    #cd5_variable_name: campo["nome variavel cd5"],
    #cd5_origin_format: campo["formato CD5"],
    #cd5_origin_format_desc: campo["Descrição formato origem CD5"],
    #cd5_format: campo["formato origem CD5"],
    #cd5_format_desc: "",
    #default_value: campo["Valor padrão"],
    room_2_notes: campo["observação dala 2"],
    domain: "a verificar",
    dmt_notes: "a verificar",
    fmbase_format_datyp: "a verificar", 
    generic_datyp: "a verificar",
    cd5_origin_frmt_datyp: "a verificar", 
    cd5_frmt_origin_desc_datyp: "a verificar",
    default_value_datyp: "a verificar",
    origin: campo["mnmonico Origem"]
  )
end

puts ""

puts "####### deleting all campaign"
Campaign.delete_all

CSV.read("db/fixtures/campanha.csv", { headers: true, :col_sep => ";"}).each_with_index do |campo, i|
  puts "####### creating campaign #{i + 1}"

  Campaign.create(
    ident: campo["ID"],
    name: campo["nome da campanha"],
    priority: campo["prioridade"],
    created_in_sprint: campo["sprint em que foi criada"],
    updated_in_sprint: campo["sprint em que foi alterada"],
    campaign_origin: campo["origem da campanha"],
    channel: campo["canal"],
    communication_channel: campo["codigo da comunicação"],
    product: campo["produto"],
    description: campo["descrição da campanha"],
    criterion: campo["critério da campanha"],
    exists_in_legacy: campo["Campanha existe no legado?"],
    automatic_routine: campo["rotina automatica"],
    factory_criterion_status: campo["Status de Levantamento de critério de fábrica"],
    prioritized_variables_qty: campo["quantidade de variáveis priorizadas"],
    complied_variables_qty: campo["quantidade de variáveis atendidas"],
    process_type: campo["Tipo de processo"],
    crm_room_suggestion: campo["Sugestão da Sala de CRM"],
    it_status: campo["Status TI"],
    notes: campo["Observações"],
    status: Constants::STATUS[:SALA1]
  )
end

puts ""

puts "####### deleting all tables"
Table.delete_all

CSV.read("db/fixtures/tabela.csv", { headers: true, :col_sep => ","}).each_with_index do |campo, i|
  puts "####### creating table #{i + 1}"

  Table.create(
    logic_table_name: campo["nome tabela logica"],
    name: campo["Descrição da tabela"],
    key: campo["chave da tabela"],
    initial_volume: campo["Volume Inicial"],
    growth_estimation: campo["Estimativa de Crescimento"],
    created_in_sprint: campo["sprint em que foi criada"],
    updated_in_sprint: campo["sprint em que foi alterada"],
    room_1_notes: campo["observações sala 1"],
    final_physical_table_name: campo["Nome tabela fisica definitiva"],
    mirror_physical_table_name: campo["nome tabela fisica espelho"],
    final_table_number: campo["numero tabela definitiva"],
    mirror_table_number: campo["numero tabela espelho"],
    mnemonic: campo["mnmonico"],
    routine_number: campo["numero rotina"],
    master_base: campo["base mestra"],
    hive_table: campo["tabela hive"],
    big_data_routine_name: campo["nome rotina big data"],
    output_routine_name: campo["nome rotina saida"],
    ziptrans_routine_name: campo["nome rotina ziptrans"],
    mirror_data_stage_routine_name: campo["nome rotina data stage espelho"],
    final_data_stage_routine_name: campo["nome rotina data stage definitivo"],
    room_2_notes: campo["observação sala 2"],
    status: Constants::STATUS[:SALA2]
  )
end

puts "####### deleting all variables"
Variable.delete_all

CSV.read("db/fixtures/variavel.csv", { headers: true, :col_sep => ","}).each_with_index do |campo, i|
  puts "####### creating variable #{i + 1}"

  Variable.create(
    name: campo["nome da variavel"],
    sas_variable_def: campo["Definição da variavel SAS"],
    sas_variable_domain: campo["Domínio da variavel SAS"],
    sas_update_periodicity: campo["Periodicidade da atualização SAS"],
    key: campo["chave da variavel"],
    data_type: campo["tipo de dado"],
    variable_type: campo["tipo de variavel"],
    created_in_sprint: campo["sprint em que foi criado"],
    updated_in_sprint: campo["sprint em que foi alterado"],
    sas_data_model_status: campo["Status Modelo de Dados SAS"],
    drs_bi_diagram_name: campo["Nome do Diagrama DRS-BI"],
    drs_variable_status: campo["Status DRS da Variavel"],
    room_1_notes: campo[" Observação Sala 1"],
    model_field_name: campo["nome do campo modelo fisico"],
    width: campo["tamanho"],
    decimal: campo["decimal"],
    default_value: campo[" valor padrão"],
    room_2_notes: campo[" observação sala 2"],
    status: Constants::STATUS[:SALA1]
  )
end

