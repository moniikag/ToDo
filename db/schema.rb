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

ActiveRecord::Schema.define(version: 20150304110830) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags_todo_items", id: false, force: true do |t|
    t.integer "tag_id"
    t.integer "todo_item_id"
  end

  add_index "tags_todo_items", ["tag_id"], name: "index_tags_todo_items_on_tag_id", using: :btree
  add_index "tags_todo_items", ["todo_item_id"], name: "index_tags_todo_items_on_todo_item_id", using: :btree

  create_table "todo_items", force: true do |t|
    t.integer  "todo_list_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "completed_at"
    t.datetime "deadline"
  end

  add_index "todo_items", ["todo_list_id"], name: "index_todo_items_on_todo_list_id", using: :btree

  create_table "todo_lists", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
