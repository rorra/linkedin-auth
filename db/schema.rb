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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120811093213) do

  create_table "linkedin_companies", :force => true do |t|
    t.integer  "linkedin_id"
    t.string   "name"
    t.string   "company_type"
    t.string   "size"
    t.string   "industry"
    t.string   "ticker"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "linkedin_connections", :force => true do |t|
    t.integer  "location_id"
    t.string   "linkedin_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.string   "industry"
    t.string   "picture_url"
    t.string   "public_profile_url"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "linkedin_educations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "linkedin_id"
    t.string   "school_name"
    t.string   "field_of_study"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "degree"
    t.string   "activities"
    t.string   "notes"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "linkedin_groups", :force => true do |t|
    t.integer  "linkedin_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "linkedin_locations", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "linkedin_positions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "linkedin_company_id"
    t.integer  "linkedin_id"
    t.boolean  "is_current"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "title"
    t.text     "summary"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "user_connections", :force => true do |t|
    t.integer  "user_id"
    t.integer  "linkedin_connection_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "user_connections", ["user_id", "linkedin_connection_id"], :name => "index_user_connections_on_user_id_and_linkedin_connection_id"

  create_table "user_groups", :force => true do |t|
    t.integer  "user_id"
    t.integer  "linkedin_group_id"
    t.string   "linkedin_id"
    t.string   "membership_state"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "linkedin_uid"
    t.string   "linkedin_token"
    t.string   "linkedin_secret"
    t.integer  "linkedin_location_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "headline"
    t.string   "industry"
    t.string   "picture_url"
    t.string   "public_profile_url"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
