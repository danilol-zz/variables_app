class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string  :file_name                      , limit: 50, null: false
      t.string  :file_description               , limit: 200, null: false
      t.integer :created_in_sprint              , null: false
      t.integer :updated_in_sprint              , null: false
      t.string  :abbreviation                   , limit: 3, null:false
      t.string  :base_type                      , null: false
      t.string  :book_mainframe                 , limit: 10
      t.string  :periodicity                    , null: false
      t.string  :periodicity_details            , limit: 50
      t.string  :data_retention_type            , null: false
      t.string  :extractor_file_type            , null: false
      t.text    :room_1_notes                   , limit: 500
      t.string  :mnemonic                       , limit: 4, null: false, unique: true
      t.integer :cd5_portal_origin_code         , null: false, unique: true
      t.string  :cd5_portal_origin_name
      t.integer :cd5_portal_destination_code    , null: false, unique: true
      t.string  :cd5_portal_destination_name
      t.string  :hive_table_name
      t.string  :mainframe_storage_type         , null: false
      t.text    :room_2_notes                   , limit: 500
      t.string  :dmt_advice                     , limit: 200
      t.string  :dmt_classification             , null: false
      t.string  :status                         , null: false

      t.timestamps
    end

    add_index :origins, :created_in_sprint
    add_index :origins, :updated_in_sprint
    add_index :origins, :status
  end
end
