# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_04_180016) do
  create_table "events", force: :cascade do |t|
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "ends_at"
    t.string "name", null: false
    t.datetime "sales_end_date"
    t.datetime "starts_at"
    t.integer "status"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "venue_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "confirmation_code"
    t.datetime "created_at", null: false
    t.integer "event_id"
    t.integer "status"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "event_id"
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string "attendee_email"
    t.string "attendee_name"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.integer "reservation_id", null: false
    t.integer "ticket_type"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tickets_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role"
    t.datetime "updated_at", null: false
  end

  create_table "venues", force: :cascade do |t|
    t.string "address"
    t.integer "capacity"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end
end
