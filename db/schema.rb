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

ActiveRecord::Schema.define(version: 2022_03_01_114930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "country"
    t.string "phone_number"
    t.string "siren"
    t.string "siret"
    t.string "email"
    t.string "vat_number"
    t.string "bank_account"
    t.string "legal_status"
    t.string "capital"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "company_partnerships", force: :cascade do |t|
    t.string "client"
    t.string "supplier"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.bigint "partner_id"
    t.index ["company_id"], name: "index_company_partnerships_on_company_id"
    t.index ["partner_id"], name: "index_company_partnerships_on_partner_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.date "issue_date"
    t.string "po_number"
    t.string "vat_rate"
    t.string "total_wo_tax"
    t.string "status"
    t.date "payment_deadline"
    t.date "payment_date"
    t.boolean "archived"
    t.string "decline_reason"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sender_id"
    t.bigint "recipient_id"
    t.string "payment_method"
    t.string "total_w_tax"
    t.string "tax_amount"
    t.index ["recipient_id"], name: "index_invoices_on_recipient_id"
    t.index ["sender_id"], name: "index_invoices_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "company_partnerships", "companies"
  add_foreign_key "company_partnerships", "companies", column: "partner_id"
  add_foreign_key "invoices", "companies", column: "recipient_id"
  add_foreign_key "invoices", "companies", column: "sender_id"
  add_foreign_key "users", "companies"
end
