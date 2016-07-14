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

ActiveRecord::Schema.define(version: 20160707020903) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meetings", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "uuid"
    t.string   "host_email"
    t.string   "id_of_meeting"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "participant_count"
    t.boolean  "has_pstn",          default: false
    t.boolean  "has_voip",          default: false
    t.boolean  "has_video",         default: false
    t.boolean  "has_screen_share",  default: false
    t.integer  "recording"
  end

  add_index "meetings", ["host_email"], name: "index_meetings_on_host_email", using: :btree
  add_index "meetings", ["uuid"], name: "index_meetings_on_uuid", using: :btree

  create_table "participants", force: :cascade do |t|
    t.integer  "meeting_id"
    t.string   "uuid"
    t.string   "id_of_meeting"
    t.string   "user_name"
    t.string   "device"
    t.string   "ip_address"
    t.string   "country_name"
    t.string   "city"
    t.datetime "join_time"
    t.datetime "leave_time"
  end

  add_index "participants", ["uuid"], name: "index_participants_on_uuid", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "zoom_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "enable_large",     default: false
    t.integer  "large_capacity"
    t.boolean  "enable_webinar",   default: false
    t.integer  "webinar_capacity"
    t.string   "pmi"
    t.boolean  "status",           default: true
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["zoom_id"], name: "index_users_on_zoom_id", using: :btree

end
