class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string :name
      t.string :sas_variable_def
      t.string :sas_variable_domain
      t.string :sas_update_periodicity
      t.string :variable_key
      t.string :origin_and_fields
      t.string :data_type
      t.string :variable_type
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string :sas_data_model_status
      t.string :drs_bi_diagram_name
      t.string :drs_variable_status
      t.text :room_1_notes
      t.string :physical_model_name_field
      t.integer :width_variable
      t.integer :decimal_variable
      t.string :default_value
      t.text :room_2_notes

      t.timestamps
    end
  end
end
