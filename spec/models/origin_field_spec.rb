require 'rails_helper'

describe OriginField do

  it { should respond_to :field_name }
  it { should respond_to :origin_pic }
  it { should respond_to :data_type }
  it { should respond_to :fmbase_format_type }
  it { should respond_to :generic_data_type }
  it { should respond_to :decimal }
  it { should respond_to :mask }
  it { should respond_to :position }
  it { should respond_to :width }
  it { should respond_to :is_key }
  it { should respond_to :will_use }
  it { should respond_to :has_signal }
  it { should respond_to :room_1_notes }
  it { should respond_to :cd5_variable_number}
  it { should respond_to :cd5_output_order}
  it { should respond_to :cd5_variable_name }
  it { should respond_to :cd5_origin_format }
  it { should respond_to :cd5_origin_format_desc }
  it { should respond_to :cd5_format }
  it { should respond_to :cd5_format_desc }
  it { should respond_to :default_value }
  it { should respond_to :room_2_notes }
  it { should respond_to :domain }
  it { should respond_to :dmt_notes }
  it { should respond_to :origin_id }
  it { should respond_to :created_at }
  it { should respond_to :updated_at }
  it { should respond_to :origin_id }

end
