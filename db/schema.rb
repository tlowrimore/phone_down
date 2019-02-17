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

ActiveRecord::Schema.define(version: 2019_02_17_203820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pixels", force: :cascade do |t|
    t.bigint "session_id", null: false
    t.string "phone_number", null: false
    t.string "coordinate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id", "coordinate", "phone_number"], name: "udx_on_sid_and_coordinate_and_phone_number", unique: true
    t.index ["session_id"], name: "index_pixels_on_session_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
