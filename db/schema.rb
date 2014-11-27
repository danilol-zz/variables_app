# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141127153041) do

  create_table "origins", force: true do |t|
    t.string   "file_name"
    t.string   "file_description"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "abbreviation"
    t.string   "base_type"
    t.string   "book_mainframe"
    t.string   "periodicity"
    t.string   "periodicity_details"
    t.string   "data_retention_type"
    t.string   "extractor_file_type"
    t.text     "room_1_notes"
    t.string   "mnemonic"
    t.integer  "cd5_portal_origin_code"
    t.string   "cd5_portal_origin_name"
    t.integer  "cd5_portal_destination_code"
    t.string   "cd5_portal_destination_name"
    t.string   "hive_table_name"
    t.string   "mainframe_storage_type"
    t.text     "room_2_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
