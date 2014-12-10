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

ActiveRecord::Schema.define(version: 20141202120303) do

  create_table "campaigns", force: true do |t|
    t.integer  "ident"
    t.string   "name"
    t.integer  "priority"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "campaign_origin"
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
    t.string   "variable_selection"
    t.string   "status"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "origin_fields", force: true do |t|
    t.string   "field_name"
    t.string   "origin_pic"
    t.string   "data_type_origin_field"
    t.string   "fmbase_format_type"
    t.string   "generic_data_type"
    t.integer  "decimal_origin_field"
    t.string   "mask_origin_field"
    t.integer  "position_origin_field"
    t.integer  "width_origin_field"
    t.string   "is_key"
    t.string   "will_use"
    t.string   "has_signal"
    t.string   "room_1_notes"
    t.integer  "cd5_variable_number"
    t.integer  "cd5_output_order"
    t.string   "cd5_variable_name"
    t.string   "cd5_origin_format"
    t.string   "cd5_origin_format_desc"
    t.string   "cd5_format"
    t.string   "cd5_format_desc"
    t.string   "default_value"
    t.string   "room_2_notes"
    t.integer  "origin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "origin_fields", ["origin_id"], name: "index_origin_fields_on_origin_id"

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
    t.string   "status"
    t.string   "mainframe_storage_type"
    t.text     "room_2_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "processids", force: true do |t|
    t.integer  "process_number"
    t.string   "mnemonic"
    t.string   "routine_name"
    t.string   "var_select"
    t.string   "var_table_name"
    t.string   "conference_rule"
    t.string   "acceptance_percent"
    t.string   "keep_previous_work"
    t.string   "counting_rule"
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tables", force: true do |t|
    t.string   "logic_table_name"
    t.string   "name"
    t.string   "table_key"
    t.integer  "initial_volume"
    t.integer  "growth_estimation"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "variables"
    t.string   "room_1_notes"
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
    t.string   "room_2_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "sas_variable_def"
    t.string   "sas_variable_domain"
    t.string   "sas_update_periodicity"
    t.string   "variable_key"
    t.string   "origin_and_fields"
    t.string   "data_type"
    t.string   "variable_type"
    t.integer  "created_in_sprint"
    t.integer  "updated_in_sprint"
    t.string   "sas_data_model_status"
    t.string   "drs_bi_diagram_name"
    t.string   "drs_variable_status"
    t.text     "room_1_notes"
    t.string   "physical_model_name_field"
    t.integer  "width_variable"
    t.integer  "decimal_variable"
    t.string   "default_value"
    t.string   "status"
    t.text     "room_2_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
