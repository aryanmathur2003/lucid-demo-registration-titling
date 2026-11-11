ActiveRecord::Schema[7.1].define(version: 2023_04_18_000003) do
  create_table "registrations", force: :cascade do |t|
    t.string "vin", null: false
    t.string "state", null: false
    t.string "buyer_name", null: false
    t.integer "sale_price_cents", null: false
    t.integer "vehicle_weight_lbs", default: 5200, null: false
    t.boolean "financed", default: false, null: false
    t.boolean "trade_in", default: false, null: false
    t.string "status", default: "draft", null: false
    t.text "documents"
    t.integer "fee_cents"
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vin"], name: "index_registrations_on_vin", unique: true
  end

  create_table "temp_tags", force: :cascade do |t|
    t.integer "registration_id", null: false
    t.string "tag_number", null: false
    t.date "issued_on", null: false
    t.date "expires_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_temp_tags_on_registration_id"
  end

  create_table "lien_filings", force: :cascade do |t|
    t.integer "registration_id", null: false
    t.string "lienholder_name", null: false
    t.string "lienholder_code"
    t.integer "amount_cents", null: false
    t.string "status", default: "pending", null: false
    t.date "file_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_lien_filings_on_registration_id"
  end
end
