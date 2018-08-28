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

ActiveRecord::Schema.define(version: 20180828174937) do

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "change", precision: 10
    t.decimal "current", precision: 10
    t.integer "user_id"
    t.integer "shisha_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
  end

  create_table "global_events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "change", precision: 10, null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "login_tokens", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "user_id", precision: 10, null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "shishas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "price", precision: 10, null: false
    t.boolean "current", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_shishas", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "user_id", precision: 10, null: false
    t.decimal "shisha_id", precision: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :decimal, precision: 10, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean "is_bot"
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.string "language_code"
    t.decimal "money", precision: 10, default: "0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allowed", default: false, null: false
    t.boolean "super_admin", default: false, null: false
    t.text "photo_url"
    t.boolean "notify", default: false, null: false
  end

end
