json.array!(@tables) do |table|
  json.extract! table, :id, :logic_table_name, :name, :initial_volume, :growth_estimation, :created_in_sprint, :updated_in_sprint, :room_1_notes, :final_physical_table_name, :mirror_physical_table_name, :final_table_number, :mirror_table_number, :mnemonic, :routine_number, :master_base, :hive_table, :big_data_routine_name, :output_routine_name, :ziptrans_routine_name, :mirror_data_stage_routine_name, :final_data_stage_routine_name, :room_2_notes
  json.url table_url(table, format: :json)
end
