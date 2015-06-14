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

ActiveRecord::Schema.define(version: 10) do

  create_table "roles", force: :cascade do |t|
    t.string "label", null: false
  end

  add_index "roles", ["label"], name: "index_roles_on_label", unique: true

  create_table "tokens", force: :cascade do |t|
    t.string   "access_token",                                 null: false
    t.datetime "expires_at",   default: '2015-06-28 00:52:32', null: false
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
    t.string   "slug"
    t.integer  "role_id",                         null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true

end
