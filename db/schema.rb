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

ActiveRecord::Schema.define(version: 40) do

  create_table "event_categories", force: :cascade do |t|
    t.integer  "event_id",   null: false
    t.string   "label",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_categories", ["event_id", "label"], name: "index_event_categories_on_event_id_and_label", unique: true
  add_index "event_categories", ["event_id"], name: "index_event_categories_on_event_id"

  create_table "event_judges", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "judge_id", null: false
  end

  add_index "event_judges", ["event_id", "judge_id"], name: "index_event_judges_on_event_id_and_judge_id", unique: true

  create_table "event_organizers", force: :cascade do |t|
    t.integer  "event_id",     null: false
    t.integer  "organizer_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "event_organizers", ["event_id", "organizer_id"], name: "index_event_organizers_on_event_id_and_organizer_id", unique: true

  create_table "event_teams", force: :cascade do |t|
    t.string   "logo_id"
    t.string   "name",       null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_teams", ["event_id", "name"], name: "index_event_teams_on_event_id_and_name", unique: true
  add_index "event_teams", ["event_id"], name: "index_event_teams_on_event_id"

  create_table "events", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "location",   null: false
    t.datetime "start_time", null: false
    t.datetime "end_time",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",                                 null: false
    t.datetime "expires_at",   default: '2015-07-06 00:35:23', null: false
    t.integer  "user_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "tokens", ["access_token"], name: "index_tokens_on_access_token", unique: true

  create_table "users", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.boolean  "admin",           default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
