require 'rails_helper'

describe Table do

  it { should respond_to :logic_table_name }
  it { should respond_to :name }
  it { should respond_to :initial_volume }
  it { should respond_to :growth_estimation }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :room_1_notes }
  it { should respond_to :final_physical_table_name }
  it { should respond_to :mirror_physical_table_name }
  it { should respond_to :final_table_number }
  it { should respond_to :mirror_table_number }
  it { should respond_to :mnemonic }
  it { should respond_to :routine_number }
  it { should respond_to :master_base }
  it { should respond_to :hive_table }
  it { should respond_to :big_data_routine_name }
  it { should respond_to :output_routine_name }
  it { should respond_to :ziptrans_routine_name }
  it { should respond_to :mirror_data_stage_routine_name }
  it { should respond_to :final_data_stage_routine_name }
  it { should respond_to :room_2_notes }

end
