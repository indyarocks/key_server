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

ActiveRecord::Schema.define(version: 20161118131913) do

  create_table "keys", force: :cascade do |t|
    t.text     "token"
    t.integer  "status",         default: 0, null: false
    t.datetime "created_at"
    t.datetime "assigned_at"
    t.datetime "released_at"
    t.datetime "deleted_at"
    t.datetime "renewed_at"
    t.integer  "renewal_status"
    t.index ["token", "status"], name: "TOKEN_WITH_STATUS_INDEX"
    t.index ["token"], name: "UNIQUE_TOKEN_INDEX_ON_KEYS", unique: true
  end

end
