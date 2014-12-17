class CreateOriginFields < ActiveRecord::Migration
  def change
    create_table :origin_fields do |t|      
      t.string  :field_name         
      t.string  :origin_pic 
      t.string  :data_type 
      t.integer :decimal 
      t.string  :mask
      t.integer :position
      t.integer :width
      t.string  :is_key
      t.string  :will_use
      t.string  :has_signal
      t.text    :room_1_notes
      t.integer :cd5_variable_number
      t.integer :cd5_output_order
      t.text    :room_2_notes
      t.string  :domain
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

