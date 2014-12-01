json.array!(@origin_fields) do |origin_field|
  json.extract! origin_field, :id, :field_name, :origin_pic, :data_type_origin_field, :fmbase_format_type, :generic_data_type, :decimal_origin_field, :mask_origin_field, :position_origin_field, :width_origin_field, :is_key, :will_use, :has_signal, :room_1_notes, :cd5_variable_number, :cd5_output_order, :cd5_variable_name, :cd5_origin_format, :cd5_origin_format_desc, :cd5_format, :cd5_format_desc, :default_value, :room_2_notes, :origin_id
  json.url origin_field_url(origin_field, format: :json)
end