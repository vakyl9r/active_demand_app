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

ActiveRecord::Schema.define(version: 2018_09_24_080041) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abandoned_carts", force: :cascade do |t|
    t.bigint "shop_id"
    t.boolean "enable", default: false
    t.text "fields", default: ["email", "id", "total_price", "subtotal_price", "line_items", "abandoned_checkout_url", "first_name", "last_name", "name", "phone", "country", "province", "city", "address1", "address2", "zip", "company", "latitude", "longitude", "country_code", "province_code", "customer_id", "customer_email", "customer_accepts_marketing", "customer_created_at", "customer_updated_at", "customer_first_name", "customer_last_name", "customer_orders_count", "customer_state", "customer_total_spent", "customer_last_order_id", "customer_note", "customer_verified_email", "customer_multipass_identifier", "customer_tax_exempt", "customer_phone", "customer_tags", "customer_last_order_name"], array: true
    t.jsonb "ad_fields", default: [], array: true
    t.string "form_id"
    t.integer "time", default: 1
    t.string "time_parser", default: "Hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_abandoned_carts_on_shop_id"
  end

  create_table "active_demand_webhooks", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "form_id"
    t.jsonb "fields", default: [], array: true
    t.index ["shop_id"], name: "index_active_demand_webhooks_on_shop_id"
  end

  create_table "adkeys", force: :cascade do |t|
    t.string "key"
    t.bigint "shop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_adkeys_on_shop_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "webhook_names", force: :cascade do |t|
    t.string "name"
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "fields", default: [], array: true
  end

  add_foreign_key "abandoned_carts", "shops"
  add_foreign_key "active_demand_webhooks", "shops"
  add_foreign_key "adkeys", "shops"
end
