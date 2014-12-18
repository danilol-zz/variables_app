class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string  :file_name,                  limit: 50
      t.string  :file_description,           limit: 200
      t.integer :created_in_sprint
      t.integer :updated_in_sprint
      t.string  :abbreviation,               limit: 3
      t.string  :base_type
      t.string  :book_mainframe,             limit: 10
      t.string  :periodicity
      t.string  :periodicity_details,         limit: 50
      t.string  :data_retention_type
      t.string  :extractor_file_type
      t.text    :room_1_notes,                limit: 500
      t.string  :mnemonic,                    limit: 4, unique: true
      t.integer :cd5_portal_origin_code,      unique: true
      t.string  :cd5_portal_origin_name
      t.integer :cd5_portal_destination_code, unique: true
      t.string  :cd5_portal_destination_name
      t.string  :hive_table_name
      t.string  :mainframe_storage_type
      t.text    :room_2_notes,                limit: 500
      t.string  :dmt_advice,                  limit: 200
      t.string  :dmt_classification
      t.string  :status,                      default: Constants::STATUS[:SALA1]

      t.timestamps
    end

    add_index :origins, :created_in_sprint
    add_index :origins, :updated_in_sprint
    add_index :origins, :status
  end
end
