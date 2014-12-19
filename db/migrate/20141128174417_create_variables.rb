class CreateVariables < ActiveRecord::Migration
  def change
    create_table :variables do |t|
      t.string  :name
      t.string  :model_field_name
      t.string  :data_type
      t.integer :width
      t.integer :decimal
      t.text    :sas_variable_def
      t.text    :sas_variable_rule_def
      t.string  :sas_update_periodicity
      t.string  :domain_type
      t.text    :sas_variable_domain
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string  :sas_data_model_status
      t.string  :drs_bi_diagram_name
      t.string  :drs_variable_status
      t.text    :room_1_notes
      t.string  :variable_type
      t.string  :default_value
      t.text    :room_2_notes
      t.string  :owner
      t.string  :status

      t.timestamps
    end
  end
end

