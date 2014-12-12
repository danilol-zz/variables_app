class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string  :file_name
      t.string  :file_description
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string  :abbreviation
      t.string  :base_type
      t.string  :book_mainframe
      t.string  :periodicity
      t.string  :periodicity_details
      t.string  :data_retention_type
      t.string  :extractor_file_type
      t.text    :room_1_notes
      t.string  :mnemonic
      t.integer :cd5_portal_origin_code
      t.string  :cd5_portal_origin_name
      t.integer :cd5_portal_destination_code
      t.string  :cd5_portal_destination_name
      t.string  :hive_table_name
      t.string  :mainframe_storage_type
      t.text    :room_2_notes
      t.string  :dmt_advice
      t.string  :dmt_classification

      t.string  :status
      t.timestamps
    end
  end
end

