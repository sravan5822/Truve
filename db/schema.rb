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

ActiveRecord::Schema.define(version: 20140910070210) do

  create_table "comments", force: true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", id: false, force: true do |t|
    t.string "origin"
    t.string "friend"
  end

  add_index "friendships", ["friend"], name: "index_friendships_on_friend"
  add_index "friendships", ["origin", "friend"], name: "index_friendships_on_origin_and_friend", unique: true
  add_index "friendships", ["origin"], name: "index_friendships_on_origin"

  create_table "images", force: true do |t|
    t.integer  "product_id"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.text     "content"
    t.datetime "read_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["recipient_id"], name: "index_messages_on_recipient_id"
  add_index "messages", ["sender_id"], name: "index_messages_on_sender_id"

  create_table "products", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.decimal  "price",       precision: 8, scale: 2
    t.string   "brand"
    t.string   "condition"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["user_id"], name: "index_products_on_user_id"

  create_table "users", force: true do |t|
    t.text     "fb_oauth_token",                limit: 255
    t.text     "fb_refresh_token",              limit: 255
    t.string   "fb_user_id"
    t.string   "email"
    t.string   "gender"
    t.date     "birthday"
    t.string   "time"
    t.string   "city"
    t.string   "country"
    t.text     "avatar_url"
    t.text     "meta"
    t.boolean  "receive_emails"
    t.boolean  "share_with_friends_of_friends"
    t.text     "friends_of_friends_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "device_token"
  end

end
