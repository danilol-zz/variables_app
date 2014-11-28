json.array!(@variables) do |variable|
  json.extract! variable, :id, :name, :sas_variable_def, :sas_variable_domain, :created_in_sprint, :updated_in_sprint, :sas_data_model_status, :drs_bi_diagram_name, :drs_variable_status, :room_1_notes, :physical_model_name_field, :width_variable, :decimal_variable, :default_value, :room_2_notes
  json.url variable_url(variable, format: :json)
end
