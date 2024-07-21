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

ActiveRecord::Schema[7.1].define(version: 2024_07_18_235538) do
  create_table "order_details", force: :cascade do |t|
    t.integer "order_amount"
    t.integer "received_amount"
    t.integer "order_unit"
    t.date "wanted_delay"
    t.date "confirmed_delay"
    t.float "unit_price"
    t.string "status"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_header_id", null: false
    t.integer "product_id", null: false
    t.index ["order_header_id"], name: "index_order_details_on_order_header_id"
    t.index ["product_id"], name: "index_order_details_on_product_id"
  end

  create_table "order_headers", force: :cascade do |t|
    t.string "status"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "provider_id"
    t.index ["provider_id"], name: "index_order_headers_on_provider_id"
  end

  create_table "products", force: :cascade do |t|
    t.text "description"
    t.integer "stocking_unit"
    t.string "familiy"
    t.float "net_unit_weight"
    t.float "brut_unit_weight"
    t.integer "total_available_stock"
    t.integer "total_unavailable_stock"
    t.integer "on_hold_sale_quantity"
    t.integer "on_hold_delivery_quantity"
    t.string "default_location"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "providers", force: :cascade do |t|
    t.text "description"
    t.string "address1"
    t.string "adresse2"
    t.integer "zipcode"
    t.string "contact_name"
    t.string "contact_mail"
    t.string "iban"
    t.string "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "order_details", "order_headers"
  add_foreign_key "order_details", "products"
  add_foreign_key "order_headers", "providers"
end
