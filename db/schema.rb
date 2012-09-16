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

ActiveRecord::Schema.define(:version => 20120916162252) do

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "groups_recipients", :id => false, :force => true do |t|
    t.integer "group_id"
    t.integer "recipient_id"
  end

  add_index "groups_recipients", ["group_id", "recipient_id"], :name => "index_groups_recipients_on_group_id_and_recipient_id"
  add_index "groups_recipients", ["recipient_id", "group_id"], :name => "index_groups_recipients_on_recipient_id_and_group_id"

  create_table "recipients", :force => true do |t|
    t.string   "external_id"
    t.string   "recipient_type"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipients", ["external_id", "recipient_type"], :name => "index_recipients_on_external_id_and_recipient_type", :unique => true
  add_index "recipients", ["recipient_type"], :name => "index_recipients_on_recipient_type"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "name"
    t.integer  "roles_mask"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
