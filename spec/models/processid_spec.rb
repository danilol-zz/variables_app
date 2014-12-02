require 'rails_helper'

describe Processid do

  it { should respond_to :process_number }
  it { should respond_to :mnemonic }
  it { should respond_to :routine_name }
  it { should respond_to :var_table_name }
  it { should respond_to :conference_rule }
  it { should respond_to :acceptance_percent }
  it { should respond_to :keep_previous_work }
  it { should respond_to :counting_rule }
  it { should respond_to :notes }

end
