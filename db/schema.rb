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

ActiveRecord::Schema[7.0].define(version: 2023_08_26_021207) do
  create_table "requests", force: :cascade do |t|
    t.string "nickname"
    t.string "email"
    t.boolean "approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.string "name"
    t.string "currency"
    t.decimal "amount"
    t.string "symbol"
    t.decimal "asset"
    t.integer "trader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trader_id"], name: "index_stocks_on_trader_id"
  end

  create_table "traders", force: :cascade do |t|
    t.string "name"
    t.text "stock"
    t.text "transaction_history"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_traders_on_user_id"
  end

  create_table "transaction_histories", force: :cascade do |t|
    t.text "trader_info"
    t.text "stock_info"
    t.integer "trader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trader_id"], name: "index_transaction_histories_on_trader_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_hash"
    t.string "token"
    t.text "trader"
    t.boolean "is_admin"
    t.boolean "is_trader"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "stocks", "traders"
  add_foreign_key "traders", "users"
  add_foreign_key "transaction_histories", "traders"
end
