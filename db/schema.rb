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

ActiveRecord::Schema.define(version: 20150924185121) do

  create_table "fbcomments", force: :cascade do |t|
    t.string   "user_name"
    t.string   "message"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "fbpost_id"
    t.string   "gender"
    t.string   "bpopToken"
    t.string   "date"
    t.string   "user_facebook_id"
  end

  add_index "fbcomments", ["fbpost_id"], name: "index_fbcomments_on_fbpost_id"

  create_table "fblikes", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "user_facebook_id"
    t.string   "user_name"
    t.string   "gender"
    t.integer  "fbpost_id"
    t.string   "bpopToken"
    t.string   "date"
  end

  add_index "fblikes", ["fbpost_id"], name: "index_fblikes_on_fbpost_id"

  create_table "fbposts", force: :cascade do |t|
    t.text     "story"
    t.text     "message"
    t.string   "likes"
    t.string   "url"
    t.string   "date"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "likes_data"
    t.text     "fb_user_token"
    t.string   "likesGenderPercentage"
    t.string   "commentsGenderPercentage"
    t.text     "comments_data"
    t.string   "bpopToken"
    t.string   "comments"
    t.string   "owner"
    t.string   "picture"
    t.string   "fb_post_id"
    t.integer  "user_id"
    t.string   "is_last"
  end

  add_index "fbposts", ["user_id"], name: "index_fbposts_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "bpopToken"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "tempPostsIdContainer"
    t.boolean  "is_parsing_complete",  default: false
  end

end
