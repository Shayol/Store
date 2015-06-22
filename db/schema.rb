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

ActiveRecord::Schema.define(version: 20150620043055) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.text     "address",    null: false
    t.text     "zipcode",    null: false
    t.text     "city",       null: false
    t.text     "phone",      null: false
    t.integer  "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["country_id"], name: "index_addresses_on_country_id", using: :btree

  create_table "authors", force: :cascade do |t|
    t.text     "firstname",  null: false
    t.text     "lastname",   null: false
    t.text     "biography"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.text     "title",       null: false
    t.text     "description"
    t.decimal  "price",       null: false
    t.integer  "amount",      null: false
    t.integer  "author_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["category_id"], name: "index_books_on_category_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.text     "title",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "categories", ["title"], name: "index_categories_on_title", unique: true, using: :btree

  create_table "countries", force: :cascade do |t|
    t.text     "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "countries", ["name"], name: "index_countries_on_name", unique: true, using: :btree

  create_table "credit_cards", force: :cascade do |t|
    t.text     "number",           null: false
    t.text     "expiration_month", null: false
    t.integer  "expiration_year",  null: false
    t.text     "firstname",        null: false
    t.text     "lastname",         null: false
    t.text     "CVV",              null: false
    t.integer  "customer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "credit_cards", ["customer_id"], name: "index_credit_cards_on_customer_id", using: :btree

  create_table "customers", force: :cascade do |t|
    t.text     "email",      null: false
    t.text     "password",   null: false
    t.text     "firstname",  null: false
    t.text     "lastname",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree

  create_table "order_items", force: :cascade do |t|
    t.decimal  "price",      precision: 9, scale: 2, null: false
    t.integer  "quantity",                           null: false
    t.integer  "book_id"
    t.integer  "order_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "order_items", ["book_id"], name: "index_order_items_on_book_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.decimal  "total_price",         default: 0.0,           null: false
    t.datetime "completed_date"
    t.string   "state",               default: "in progress", null: false
    t.integer  "customer_id"
    t.integer  "credit_card_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "orders", ["credit_card_id"], name: "index_orders_on_credit_card_id", using: :btree
  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree

  create_table "raitings", force: :cascade do |t|
    t.text     "review"
    t.integer  "raiting_number"
    t.integer  "customer_id"
    t.integer  "book_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "raitings", ["book_id"], name: "index_raitings_on_book_id", using: :btree
  add_index "raitings", ["customer_id"], name: "index_raitings_on_customer_id", using: :btree

  add_foreign_key "addresses", "countries"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "categories"
  add_foreign_key "credit_cards", "customers"
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "credit_cards"
  add_foreign_key "orders", "customers"
  add_foreign_key "raitings", "books"
  add_foreign_key "raitings", "customers"
end
