require 'rails_helper'

describe Origin do

  it { should respond_to :file_name }
  it { should respond_to :file_description }
  it { should respond_to :created_in_sprint }
  it { should respond_to :updated_in_sprint }
  it { should respond_to :abbreviation }
  it { should respond_to :base_type }
  it { should respond_to :book_mainframe }
  it { should respond_to :periodicity }
  it { should respond_to :periodicity_details }
  it { should respond_to :data_retention_type }
  it { should respond_to :extractor_file_type }
  it { should respond_to :room_1_notes }
  it { should respond_to :mnemonic }
  it { should respond_to :cd5_portal_source_code }
  it { should respond_to :cd5_portal_source_name }
  it { should respond_to :cd5_portal_target_code }
  it { should respond_to :cd5_portal_target_name }
  it { should respond_to :hive_table_name }
  it { should respond_to :mainframe_storage_type }
  it { should respond_to :room_2_notes }

end
