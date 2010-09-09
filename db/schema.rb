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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100821113544) do

  create_table "app_configs", :force => true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "app_configs", ["name"], :name => "index_app_configs_on_name", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "media_items", :force => true do |t|
    t.string   "title",                                    :null => false
    t.integer  "depositor_id",                             :null => false
    t.string   "original_file_name"
    t.string   "original_content_type"
    t.string   "original_file_size"
    t.datetime "original_updated_at"
    t.string   "item_id"
    t.datetime "recorded_at"
    t.string   "annotator_name"
    t.string   "annotator_role"
    t.string   "presenter_name"
    t.string   "presenter_role"
    t.string   "language_code"
    t.string   "copyright"
    t.string   "license"
    t.boolean  "private",               :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "original_processing"
  end

  add_index "media_items", ["item_id"], :name => "index_media_items_on_item_id", :unique => true

  create_table "transcript_phrases", :force => true do |t|
    t.integer "transcript_tier_id", :null => false
    t.string  "phrase_id"
    t.float   "start_time",         :null => false
    t.float   "end_time",           :null => false
    t.string  "text"
    t.string  "participant"
    t.string  "ref_phrase"
  end

  create_table "transcript_tiers", :force => true do |t|
    t.integer "transcript_id",   :null => false
    t.integer "parent_id"
    t.string  "tier_id"
    t.string  "language_code"
    t.string  "linguistic_type"
  end

  add_index "transcript_tiers", ["transcript_id", "tier_id"], :name => "index_transcript_tiers_on_transcript_id_and_tier_id", :unique => true

  create_table "transcripts", :force => true do |t|
    t.integer  "media_item_id",         :null => false
    t.integer  "depositor_id",          :null => false
    t.string   "creator"
    t.string   "language_code"
    t.string   "date"
    t.string   "original_file_name"
    t.string   "original_content_type"
    t.string   "original_file_size"
    t.datetime "original_updated_at"
    t.string   "transcript_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "roles"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
