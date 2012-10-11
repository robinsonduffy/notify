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

ActiveRecord::Schema.define(:version => 20121011024013) do

  create_table "contact_methods", :force => true do |t|
    t.string   "contact_method_type"
    t.string   "delivery_route"
    t.integer  "recipient_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contact_methods", ["recipient_id"], :name => "index_contact_methods_on_recipient_id"

  create_table "contact_methods_lists", :id => false, :force => true do |t|
    t.integer "contact_method_id"
    t.integer "list_id"
  end

  add_index "contact_methods_lists", ["contact_method_id", "list_id"], :name => "index_contact_methods_lists_on_contact_method_id_and_list_id"
  add_index "contact_methods_lists", ["list_id", "contact_method_id"], :name => "index_contact_methods_lists_on_list_id_and_contact_method_id"

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

  create_table "linked_recipients", :force => true do |t|
    t.integer  "student_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "linked_recipients", ["parent_id", "student_id"], :name => "index_linked_recipients_on_parent_id_and_student_id", :unique => true
  add_index "linked_recipients", ["parent_id"], :name => "index_linked_recipients_on_parent_id"
  add_index "linked_recipients", ["student_id"], :name => "index_linked_recipients_on_student_id"

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["user_id"], :name => "index_lists_on_user_id"

  create_table "message_permissions", :force => true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_permissions", ["user_id", "object_id", "object_type"], :name => "index_message_permissions_on_object_combo", :unique => true

  create_table "message_recipients", :force => true do |t|
    t.integer  "message_id"
    t.integer  "object_id"
    t.string   "object_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_recipients", ["message_id", "object_id", "object_type"], :name => "index_message_recipients_on_object_combo", :unique => true

  create_table "messages", :force => true do |t|
    t.integer  "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "recipient_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recipients", :force => true do |t|
    t.string   "external_id"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "recipient_type_id"
  end

  add_index "recipients", ["external_id", "recipient_type_id"], :name => "index_recipients_on_external_id_and_recipient_type_id", :unique => true
  add_index "recipients", ["recipient_type_id"], :name => "index_recipients_on_recipient_type_id"

  create_table "recipients_schools", :id => false, :force => true do |t|
    t.integer "recipient_id"
    t.integer "school_id"
  end

  add_index "recipients_schools", ["recipient_id", "school_id"], :name => "index_recipients_schools_on_recipient_id_and_school_id"
  add_index "recipients_schools", ["school_id", "recipient_id"], :name => "index_recipients_schools_on_school_id_and_recipient_id"

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
