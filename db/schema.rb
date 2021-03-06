# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_190_508_092_505) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'discounts', force: :cascade do |t|
    t.string 'kind'
    t.string 'name'
    t.float 'price'
    t.integer 'count'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'discounts_products', id: false, force: :cascade do |t|
    t.bigint 'product_id', null: false
    t.bigint 'discount_id', null: false
    t.index %w[discount_id product_id], name: 'index_discounts_products_on_discount_id_and_product_id'
    t.index %w[product_id discount_id], name: 'index_discounts_products_on_product_id_and_discount_id'
  end

  create_table 'items', force: :cascade do |t|
    t.bigint 'product_id'
    t.integer 'quantity', default: 1
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['product_id'], name: 'index_items_on_product_id'
  end

  create_table 'products', force: :cascade do |t|
    t.string 'name'
    t.float 'price'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['name'], name: 'index_products_on_name', unique: true
  end

  add_foreign_key 'items', 'products'
end
