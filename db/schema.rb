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

ActiveRecord::Schema.define(:version => 20120916170045) do

  create_table "contact_methods", :force => true do |t|
    t.string   "contact_method_type"
    t.string   "delivery_route"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_methods", ["recipient_id"], :name => "index_contact_methods_on_recipient_id"

  create_table "delivery_options", :force => true do |t|
    t.string   "option_scope"
    t.integer  "scope_id"
    t.integer  "options_mask"
    t.integer  "contact_method_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delivery_options", ["contact_method_id", "option_scope", "scope_id"], :name => "index_delivery_options_on_scope_combo"
  add_index "delivery_options", ["contact_method_id"], :name => "index_delivery_options_on_contact_method_id"

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
