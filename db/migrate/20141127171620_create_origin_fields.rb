class CreateOriginFields < ActiveRecord::Migration
  def change
    create_table :origin_fields do |t|
      t.string  :field_name
      t.string  :origin_pic
      t.string  :data_type
      t.string  :fmbase_format_type
      t.string  :generic_data_type
      t.integer :decimal
      t.string  :mask, length: 30
      t.integer :position
      t.integer :width
      t.boolean :is_key
      t.boolean :will_use
      t.boolean :has_signal
      t.text    :room_1_notes
      t.integer :cd5_variable_number, unique: true
      t.integer :cd5_output_order
      t.string  :cd5_variable_name
      t.string  :cd5_origin_format
      t.string  :cd5_origin_format_desc
      t.string  :cd5_format
      t.string  :cd5_format_desc
      t.string  :default_value
      t.text    :room_2_notes
      t.text    :domain
      t.text    :dmt_notes
      t.string  :fmbase_format_datyp
      t.string  :generic_datyp
      t.string  :cd5_origin_frmt_datyp
      t.string  :cd5_frmt_origin_desc_datyp
      t.string  :default_value_datyp
      t.references :origin,  index: true

      t.timestamps
    end
  end
end

