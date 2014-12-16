require 'rails_helper'

describe OriginField do
  it { should respond_to :field_name }   
  it { should respond_to :origin_pic }
  it { should respond_to :data_type }
  it { should respond_to :decimal }
  it { should respond_to :mask }
  it { should respond_to :position }
  it { should respond_to :width }
  it { should respond_to :is_key }
  it { should respond_to :will_use }
  it { should respond_to :has_signal }
  it { should respond_to :room_1_notes }
  it { should respond_to :cd5_variable_number }
  it { should respond_to :cd5_output_order }
  it { should respond_to :room_2_notes }
  it { should respond_to :domain }
  it { should respond_to :dmt_notes }
  it { should respond_to :fmbase_format_datyp }
  it { should respond_to :generic_datyp }
  it { should respond_to :cd5_origin_frmt_datyp }
  it { should respond_to :cd5_frmt_origin_desc_datyp }
  it { should respond_to :default_value_datyp }
  it { should respond_to :origin_id }  
end
