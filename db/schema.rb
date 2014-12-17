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

ActiveRecord::Schema.define(version: 20141217132209) do

  create_table "campaigns", force: true do |t|
    t.string   "ident"
    t.string   "name"
    t.string   "priority"
    t.string   "campaign_origin"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "channel"
    t.string   "communication_channel"
    t.string   "product"
    t.string   "description"
    t.string   "criterion"
    t.string   "exists_in_legacy"
    t.string   "automatic_routine"
    t.string   "factory_criterion_status"
    t.integer  "prioritized_variables_qty"
    t.integer  "complied_variables_qty"
    t.string   "process_type"
    t.string   "crm_room_suggestion"
    t.string   "it_status"
    t.string   "notes"
    t.string   "owner"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns_variables", id: false, force: true do |t|
    t.integer "campaign_id"
    t.integer "variable_id"
  end

  create_table "origin_fields", force: true do |t|
    t.string   "field_name"
    t.string   "origin_pic"
    t.string   "data_type"
    t.integer  "decimal"
    t.string   "mask"
    t.integer  "position"
    t.integer  "width"
    t.string   "is_key"
    t.string   "will_use"
    t.string   "has_signal"
    t.text     "room_1_notes"
    t.integer  "cd5_variable_number"
    t.integer  "cd5_output_order"
    t.text     "room_2_notes"
    t.string   "domain"
    t.text     "dmt_notes"
    t.string   "fmbase_format_datyp"
    t.string   "generic_datyp"
    t.string   "cd5_origin_frmt_datyp"
    t.string   "cd5_frmt_origin_desc_datyp"
    t.string   "default_value_datyp"
    t.integer  "origin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "origin_fields", ["origin_id"], name: "index_origin_fields_on_origin_id"

  create_table "origins", force: true do |t|
    t.string   "file_name",                   limit: 50,                    null: false
    t.string   "file_description",            limit: 200,                   null: false
    t.integer  "created_in_sprint",                                         null: false
    t.integer  "updated_in_sprint",                                         null: false
    t.string   "abbreviation",                limit: 3,                     null: false
    t.string   "base_type",                                                 null: false
    t.string   "book_mainframe",              limit: 10
    t.string   "periodicity",                                               null: false
    t.string   "periodicity_details",         limit: 50
    t.string   "data_retention_type",                                       null: false
    t.string   "extractor_file_type",                                       null: false
    t.text     "room_1_notes",                limit: 500
    t.string   "mnemonic",                    limit: 4,                     null: false
    t.integer  "cd5_portal_origin_code",                                    null: false
    t.string   "cd5_portal_origin_name"
    t.integer  "cd5_portal_destination_code",                               null: false
    t.string   "cd5_portal_destination_name"
    t.string   "hive_table_name"
    t.string   "mainframe_storage_type",                                    null: false
    t.text     "room_2_notes",                limit: 500
    t.string   "dmt_advice",                  limit: 200
    t.string   "dmt_classification",                                        null: false
    t.string   "status",                                  default: "sala1", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "origins", ["created_in_sprint"], name: "index_origins_on_created_in_sprint"
  add_index "origins", ["status"], name: "index_origins_on_status"
  add_index "origins", ["updated_in_sprint"], name: "index_origins_on_updated_in_sprint"

  create_table "processids", force: true do |t|
    t.integer  "process_number"
    t.string   "mnemonic"
    t.string   "routine_name"
    t.string   "var_table_name"
    t.string   "conference_rule"
    t.string   "acceptance_percent"
    t.string   "keep_previous_work"
    t.string   "counting_rule"
    t.string   "notes"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "processids_variables", force: true do |t|
    t.integer "processid_id"
    t.integer "variable_id"
  end

  create_table "tables", force: true do |t|
    t.string   "logic_table_name"
    t.string   "type"
    t.string   "name"
    t.string   "key"
    t.integer  "initial_volume"
    t.integer  "growth_estimation"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.text     "room_1_notes"
    t.string   "final_physical_table_name"
    t.string   "mirror_physical_table_name"
    t.integer  "final_table_number"
    t.integer  "mirror_table_number"
    t.string   "mnemonic"
    t.integer  "routine_number"
    t.string   "master_base"
    t.string   "hive_table"
    t.string   "big_data_routine_name"
    t.string   "output_routine_name"
    t.string   "ziptrans_routine_name"
    t.string   "mirror_data_stage_routine_name"
    t.string   "final_data_stage_routine_name"
    t.text     "room_2_notes"
    t.string   "key_fields_hive_script"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables_variables", force: true do |t|
    t.integer "table_id"
    t.integer "variable_id"
  end

  create_table "users", force: true do |t|
    t.string "email"
    t.string "name"
    t.string "profile"
    t.string "password"
    t.string "role"
  end

  create_table "variables", force: true do |t|
    t.string   "name"
    t.string   "model_field_name"
    t.string   "data_type"
    t.integer  "width"
    t.integer  "decimal"
    t.string   "sas_variable_def"
    t.string   "sas_variable_rule_def"
    t.string   "sas_update_periodicity"
    t.string   "domain_type"
    t.string   "sas_variable_domain"
    t.string   "key"
    t.string   "variable_type"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "sas_data_model_status"
    t.string   "drs_bi_diagram_name"
    t.string   "drs_variable_status"
    t.text     "room_1_notes"
    t.string   "default_value"
    t.text     "room_2_notes"
    t.string   "owner"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
