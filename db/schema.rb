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

ActiveRecord::Schema.define(version: 20181105071132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "fortunes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gogos", force: :cascade do |t|
    t.string "sign"
    t.integer "kinun"
    t.integer "renai"
    t.integer "shigoto"
    t.integer "kenko"
    t.text "text", default: ""
    t.text "lucky_color", default: ""
    t.text "lucky_item", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gogototals", force: :cascade do |t|
    t.text "gold_no1", default: ""
    t.text "love_no1", default: ""
    t.text "work_no1", default: ""
    t.text "health_no1", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "total_no1", default: ""
  end

  create_table "gudetamas", force: :cascade do |t|
    t.string "sign"
    t.integer "rank"
    t.text "text", default: ""
    t.text "lucky_color", default: ""
    t.text "lucky_item", default: ""
    t.text "advice", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mezamashis", force: :cascade do |t|
    t.string "sign"
    t.integer "rank"
    t.text "text1", default: ""
    t.text "text2", default: ""
    t.text "lucky_point", default: ""
    t.text "advice", default: ""
    t.text "good_luck_charm", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sukkirisus", force: :cascade do |t|
    t.integer "month"
    t.integer "rank"
    t.text "text", default: ""
    t.text "lucky_color", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
