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

ActiveRecord::Schema.define(version: 60) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "event_categories", force: :cascade do |t|
    t.integer  "event_id",    null: false
    t.string   "label",       null: false
    t.integer  "color",       null: false
    t.datetime "due_at"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "event_categories", ["event_id", "label"], name: "index_event_categories_on_event_id_and_label", unique: true, using: :btree
  add_index "event_categories", ["event_id"], name: "index_event_categories_on_event_id", using: :btree

  create_table "event_judges", force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "judge_id", null: false
  end

  add_index "event_judges", ["event_id", "judge_id"], name: "index_event_judges_on_event_id_and_judge_id", unique: true, using: :btree

  create_table "event_organizers", force: :cascade do |t|
    t.integer  "event_id",     null: false
    t.integer  "organizer_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "event_organizers", ["event_id", "organizer_id"], name: "index_event_organizers_on_event_id_and_organizer_id", unique: true, using: :btree

  create_table "event_teams", force: :cascade do |t|
    t.string   "logo_id"
    t.string   "name",       null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "event_teams", ["event_id", "name"], name: "index_event_teams_on_event_id_and_name", unique: true, using: :btree
  add_index "event_teams", ["event_id"], name: "index_event_teams_on_event_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "location",   null: false
    t.datetime "start_time", null: false
    t.datetime "end_time",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "judge_teams", force: :cascade do |t|
    t.integer  "judge_id",   null: false
    t.integer  "team_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "judge_teams", ["judge_id", "team_id"], name: "index_judge_teams_on_judge_id_and_team_id", unique: true, using: :btree

  create_table "rubrics", force: :cascade do |t|
    t.string   "name",       null: false
    t.integer  "event_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rubrics", ["name"], name: "index_rubrics_on_name", using: :btree

  create_table "team_categories", force: :cascade do |t|
    t.integer  "team_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "team_categories", ["team_id", "category_id"], name: "index_team_categories_on_team_id_and_category_id", unique: true, using: :btree

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",                                 null: false
    t.datetime "expires_at",   default: '2015-07-23 11:35:11', null: false
    t.integer  "user_id"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "tokens", ["access_token"], name: "index_tokens_on_access_token", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "password_digest",                 null: false
    t.string   "first_name",                      null: false
    t.string   "last_name",                       null: false
    t.boolean  "admin",           default: false, null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "event_categories", "events", name: "event_category_event"
  add_foreign_key "event_judges", "events", name: "event_judge_event"
  add_foreign_key "event_judges", "users", column: "judge_id", name: "event_judge_judge"
  add_foreign_key "event_organizers", "events", name: "event_organizer_event"
  add_foreign_key "event_organizers", "users", column: "organizer_id", name: "event_organizer_organizer"
  add_foreign_key "event_teams", "events", name: "event_team_event"
  add_foreign_key "judge_teams", "event_judges", column: "judge_id", name: "judge_team_judge"
  add_foreign_key "judge_teams", "event_teams", column: "team_id", name: "judge_team_team"
  add_foreign_key "rubrics", "events", name: "rubric_event"
  add_foreign_key "team_categories", "event_categories", column: "category_id", name: "team_category_category"
  add_foreign_key "team_categories", "event_teams", column: "team_id", name: "team_category_team"
end
