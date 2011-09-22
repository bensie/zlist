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

ActiveRecord::Schema.define(:version => 20110526162141) do

  create_table "lists", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",            :default => false
    t.string   "subject_prefix"
    t.boolean  "archive_disabled",   :default => false
    t.boolean  "disabled",           :default => false
    t.string   "message_footer"
    t.text     "custom_footer_text"
    t.string   "send_replies_to"
    t.string   "permitted_to_post"
  end

  create_table "messages", :force => true do |t|
    t.integer  "topic_id"
    t.string   "subject"
    t.string   "body"
    t.integer  "subscriber_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["subscriber_id"], :name => "index_messages_on_subscriber_id"
  add_index "messages", ["topic_id"], :name => "index_messages_on_topic_id"

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "public_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_hash"
    t.string   "password_salt"
    t.boolean  "admin",         :default => false
    t.boolean  "disabled",      :default => false
  end

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subscriptions", ["list_id"], :name => "index_subscriptions_on_list_id"
  add_index "subscriptions", ["subscriber_id"], :name => "index_subscriptions_on_subscriber_id"

  create_table "topics", :force => true do |t|
    t.integer  "list_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key"
  end

  add_index "topics", ["list_id"], :name => "index_topics_on_list_id"

end
