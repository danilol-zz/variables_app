class CreateTables < ActiveRecord::Migration
  def change
    create_table :tables do |t|
      t.string  :logic_table_name
      t.string  :table_type
      t.text    :name
      t.string  :table_key
      t.integer :initial_volume
      t.integer :growth_estimation
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.text    :room_1_notes
      t.string  :final_physical_table_name
      t.string  :mirror_physical_table_name
      t.integer :final_table_number
      t.integer :mirror_table_number
      t.string  :mnemonic
      t.integer :routine_number
      t.text    :master_base
      t.string  :hive_table
      t.string  :big_data_routine_name
      t.string  :output_routine_name
      t.string  :ziptrans_routine_name
      t.string  :mirror_data_stage_routine_name
      t.string  :final_data_stage_routine_name
      t.text    :key_fields_hive_script
      t.text    :room_2_notes
      t.string  :status
      
      t.timestamps
    end
  end
end
