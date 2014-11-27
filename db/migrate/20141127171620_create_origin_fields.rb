class CreateOriginFields < ActiveRecord::Migration
  def change
    create_table :origin_fields do |t|
      t.string :field_name
      t.string :origin_pic
      t.string :data_type_origin_field
      t.string :fmbase_format_type
      t.string :generic_data_type
      t.integer :decimal_origin_field
      t.string :mask_origin_field
      t.integer :position_origin_field
      t.integer :width_origin_field
      t.string :is_key
      t.string :will_use
      t.string :has_signal
      t.string :room_1_notes
      t.integer :cd5_variable_number
      t.integer :cd5_output_order
      t.string :cd5_variable_name
      t.string :cd5_origin_format
      t.string :cd5_origin_format_desc
      t.string :cd5_format
      t.string :cd5_format_desc
      t.string :default_value
      t.string :room_2_notes
      t.references :origin,  index: true

      t.timestamps
    end
  end
end
