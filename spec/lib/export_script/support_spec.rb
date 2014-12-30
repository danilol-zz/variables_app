require 'rails_helper'

describe Support do
  context '.make_dictionary' do
    subject { Support.make_dictionary }

    it "returns a hash with mapped entities" do
      expect(subject.to_s).to eq '{"Campanha"=>{:name_entity=>"Campaign", :class_entity=>Campaign(id: integer, ident: string, name: string, priority: string, campaign_origin: string, created_in_sprint: integer, updated_in_sprint: integer, channel: string, communication_channel: string, product: string, description: text, criterion: text, exists_in_legacy: boolean, automatic_routine: string, factory_criterion_status: string, process_type: string, crm_room_suggestion: text, it_status: string, notes: string, owner: string, status: string, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "ID"=>"ident", "Nome da campanha"=>"name", "Prioridade"=>"priority", "Origem da campanha"=>"campaign_origin", "Sprint em que foi criada"=>"created_in_sprint", "Sprint em que foi alterada"=>"updated_in_sprint", "Canal"=>"channel", "Codigo de comunicação"=>"communication_channel", "Produto"=>"product", "Descrição da campanha"=>"description", "Critério da campanha"=>"criterion", "Campanha existe no legado?"=>"exists_in_legacy", "Rotina automática"=>"automatic_routine", "Status levantam.critério de fábrica"=>"factory_criterion_status", "Tipo de processo"=>"process_type", "Sugestao da sala de CRM"=>"crm_room_suggestion", "Status de TI"=>"it_status", "Observações"=>"notes", "Responsável"=>"owner", "Status"=>"status", "Created at"=>"created_at", "Updated at"=>"updated_at"}}, "Origem"=>{:name_entity=>"Origin", :class_entity=>Origin(id: integer, file_name: string, file_description: string, created_in_sprint: integer, updated_in_sprint: integer, abbreviation: string, base_type: string, book_mainframe: string, periodicity: string, periodicity_details: string, data_retention_type: string, extractor_file_type: string, room_1_notes: text, mnemonic: string, cd5_portal_origin_code: integer, cd5_portal_origin_name: string, cd5_portal_destination_code: integer, cd5_portal_destination_name: string, hive_table_name: string, mainframe_storage_type: string, room_2_notes: text, dmt_advice: string, dmt_classification: string, status: string, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "Nome da base/arquivo"=>"file_name", "Descrição da base"=>"file_description", "Sprint em que foi criado"=>"created_in_sprint", "Sprint em que foi alterado"=>"updated_in_sprint", "Sigla"=>"abbreviation", "Tipo de base"=>"base_type", "Book mainframe"=>"book_mainframe", "Periodicidade"=>"periodicity", "Detalhe da periodicidade"=>"periodicity_details", "Tipo de retenção dos dados"=>"data_retention_type", "Característica do arquivo no Extrator"=>"extractor_file_type", "Observação"=>"room_1_notes", "Mnemônico"=>"mnemonic", "Cód. origem CD5"=>"cd5_portal_origin_code", "Nome origem CD5"=>"cd5_portal_origin_name", "Cód. destino CD5"=>"cd5_portal_destination_code", "Nome destino CD5"=>"cd5_portal_destination_name", "Nome tabela hive"=>"hive_table_name", "Tipo de armazenamento mainframe"=>"mainframe_storage_type", "Observação - sala 2"=>"room_2_notes", "Parecer DMT"=>"dmt_advice", "Classificação DMT"=>"dmt_classification", "Status"=>"status", "Created at"=>"created_at", "Updated at"=>"updated_at"}}, "Campos de Origem"=>{:name_entity=>"OriginField", :class_entity=>OriginField(id: integer, field_name: string, origin_pic: string, data_type: string, fmbase_format_type: string, generic_data_type: string, decimal: integer, mask: string, position: integer, width: integer, is_key: boolean, will_use: boolean, has_signal: boolean, room_1_notes: text, cd5_variable_number: integer, cd5_output_order: integer, cd5_variable_name: string, cd5_origin_format: string, cd5_origin_format_desc: string, cd5_format: string, cd5_format_desc: string, default_value: string, room_2_notes: text, domain: text, dmt_notes: text, fmbase_format_datyp: string, generic_datyp: string, cd5_origin_frmt_datyp: string, cd5_frmt_origin_desc_datyp: string, default_value_datyp: string, origin_id: integer, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "Nome do campo"=>"field_name", "Pic Origem"=>"origin_pic", "Tipo de dado"=>"data_type", "Tipo formato fmbase"=>"fmbase_format_type", "Tipo de dado generico"=>"generic_data_type", "Decimal"=>"decimal", "Mascara"=>"mask", "Posição"=>"position", "Tam."=>"width", "É chave?"=>"is_key", "Vai usar?"=>"will_use", "Tem sinal?"=>"has_signal", "Observação sala 1"=>"room_1_notes", "Núm var cd5"=>"cd5_variable_number", "Ordem saida cd5"=>"cd5_output_order", "Nome variavel cd5"=>"cd5_variable_name", "Formato origem CD5"=>"cd5_origin_format", "Descrição formato origem CD5"=>"cd5_origin_format_desc", "Formato CD5"=>"cd5_format", "Descrição formato CD5"=>"cd5_format_desc", "Valor padrão"=>"default_value", "Observação sala 2"=>"room_2_notes", "Domínio"=>"domain", "Observação DMT"=>"dmt_notes", "Formato Base (Tipo Dado)"=>"fmbase_format_datyp", "Generico (Tipo Dado)"=>"generic_datyp", "Form. Origem cd5 (Tipo Dado)"=>"cd5_origin_frmt_datyp", "Desc. form. origem cd5 (Tipo Dado)"=>"cd5_frmt_origin_desc_datyp", "Valor Padrao (Tipo Dado)"=>"default_value_datyp", "Origin"=>"origin_id", "Created at"=>"created_at", "Updated at"=>"updated_at"}}, "Processo"=>{:name_entity=>"Processid", :class_entity=>Processid(id: integer, process_number: integer, mnemonic: string, routine_name: string, var_table_name: string, conference_rule: string, acceptance_percent: string, keep_previous_work: boolean, counting_rule: string, notes: text, status: string, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "Número processo"=>"process_number", "Mnemônico"=>"mnemonic", "Nome da rotina"=>"routine_name", "Nome tabela var"=>"var_table_name", "Regra de conferência"=>"conference_rule", "Percentual de aceite"=>"acceptance_percent", "Manter movimento anterior?"=>"keep_previous_work", "Regra de contagem"=>"counting_rule", "Observação"=>"notes", "Status"=>"status", "Created at"=>"created_at", "Updated at"=>"updated_at"}}, "Tabela"=>{:name_entity=>"Table", :class_entity=>Table(id: integer, logic_table_name: string, table_type: string, name: text, table_key: string, initial_volume: integer, growth_estimation: integer, created_in_sprint: integer, updated_in_sprint: integer, room_1_notes: text, final_physical_table_name: string, mirror_physical_table_name: string, final_table_number: integer, mirror_table_number: integer, mnemonic: string, routine_number: integer, master_base: text, hive_table: string, big_data_routine_name: string, output_routine_name: string, ziptrans_routine_name: string, mirror_data_stage_routine_name: string, final_data_stage_routine_name: string, key_fields_hive_script: text, room_2_notes: text, status: string, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "Nome tabela logica"=>"logic_table_name", "Tipo"=>"table_type", "Descrição da tabela"=>"name", "Chave"=>"table_key", "Volume inicial"=>"initial_volume", "Estimativa de crescimento"=>"growth_estimation", "Sprint em que foi criada"=>"created_in_sprint", "Sprint em que foi alterada"=>"updated_in_sprint", "Observação da sala 1"=>"room_1_notes", "Nome tabela fisica definitiva"=>"final_physical_table_name", "Nome tabela fisica espelho"=>"mirror_physical_table_name", "Numero tabela fisica definitiva"=>"final_table_number", "Numero tabela espelho"=>"mirror_table_number", "Mnemônico"=>"mnemonic", "Numero rotina"=>"routine_number", "Base mestre"=>"master_base", "Tabela hive"=>"hive_table", "Nome rotina big data"=>"big_data_routine_name", "Nome rotina saida"=>"output_routine_name", "Nome rotina ziptrans"=>"ziptrans_routine_name", "Nome rotina data stage espelho"=>"mirror_data_stage_routine_name", "Nome rotina data stage difinitivo"=>"final_data_stage_routine_name", "Campos chave script Hive"=>"key_fields_hive_script", "Observação sala 2"=>"room_2_notes", "Status"=>"status", "Created at"=>"created_at", "Updated at"=>"updated_at"}}, "Variavel"=>{:name_entity=>"Variable", :class_entity=>Variable(id: integer, name: string, model_field_name: string, data_type: string, width: integer, decimal: integer, sas_variable_def: text, sas_variable_rule_def: text, sas_update_periodicity: string, domain_type: string, sas_variable_domain: text, created_in_sprint: integer, updated_in_sprint: integer, sas_data_model_status: string, drs_bi_diagram_name: string, drs_variable_status: string, room_1_notes: text, variable_type: string, default_value: string, room_2_notes: text, owner: string, status: string, created_at: datetime, updated_at: datetime), :atribute_translate=>{"Id"=>"id", "Nome da variavel"=>"name", "Nome do campo modelo"=>"model_field_name", "Tipo de dado"=>"data_type", "Tamanho"=>"width", "Decimal"=>"decimal", "Definição da variavel SAS"=>"sas_variable_def", "Definição Regra da Variável SAS"=>"sas_variable_rule_def", "Periodicidade da atualização SAS"=>"sas_update_periodicity", "Tipo de domínio"=>"domain_type", "Domínio da variavel SAS"=>"sas_variable_domain", "Sprint em que foi criado"=>"created_in_sprint", "Sprint em que foi alterado"=>"updated_in_sprint", "Status Modelo de Dados SAS"=>"sas_data_model_status", "Nome do Diagrama DRS-BI"=>"drs_bi_diagram_name", "Status DRS da Variavel"=>"drs_variable_status", "Observação Sala 1"=>"room_1_notes", "Tipo da variável"=>"variable_type", "Valor padrão"=>"default_value", "Observação sala 2"=>"room_2_notes", "Responsável"=>"owner", "Status"=>"status", "Created at"=>"created_at", "Updated at"=>"updated_at"}}}'
    end
  end

  #context '.make_dictionary' do
    #before do
      #@dic = Generator.make_dictionary
    #end

    #it "should return error if list is invalid" do
      #list = Hash.new
      #expect(Generator.translate_list(list,@dic)).to eq nil

      #list = nil
      #expect(Generator.translate_list(list,@dic)).to eq nil

      #list=""
      #expect(Generator.translate_list(list,@dic)).to eq nil

      #list={"Processo" => nil }
      #expect(Generator.translate_list(list,@dic)).to eq nil

      #list={"Processo" => "" }
      #expect(Generator.translate_list(list,@dic)).to eq nil

      #list={"Processo" => [] }
      #expect(Generator.translate_list(list,@dic)).to eq nil
    #end

    #it "should return error if dont find a entity" do
      #list = Hash.new
      #list["Processo_Erro"] = ["Nome programa"]
      #expect(Generator.translate_list(list,@dic)).to eq nil
    #end

    #it "should return erro if dont find a attribute" do
      #list = Hash.new
      #list["Processo"] = ["Nome programa erro"]
      #expect(Generator.translate_list(list,@dic)).to eq nil
    #end

    #it "should execute sucessfull" do
      #script_mini = "<Processo.[Nome da rotina]>.SQL
        #<Processo.[Nome tabela var]>"

      #str=script_mini
      #list = Generator.get_entities_list(str)
      #list_trans = Generator.translate_list(list,@dic)
      #expect(list_trans).to be_kind_of(Hash)
      #expect(list_trans.size).to eq 1
      #expect(list_trans.has_key?("Processid")).to eq true
      #expect(list_trans["Processid"].size).to eq 2
      #expect(list_trans["Processid"][0]).to eq "routine_name"
      #expect(list_trans["Processid"][1]).to eq "var_table_name"
    #end
  #end
end
