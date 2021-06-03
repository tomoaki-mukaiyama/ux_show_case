
ActiveRecord::Schema.define(version: 2021_06_03_074627) do

  create_table "platforms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "slug"
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "icon_path"
    t.string "slug"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "isTop"
    t.string "isRecommend"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "slug", null: false
    t.index ["slug"], name: "index_tags_on_slug", unique: true
  end

  create_table "user_flow_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "user_flow_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tag_id"], name: "index_user_flow_tags_on_tag_id"
    t.index ["user_flow_id"], name: "index_user_flow_tags_on_user_flow_id"
  end

  create_table "user_flows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "platform_id", null: false
    t.string "bg_color"
    t.string "thumbnail_path"
    t.string "version"
    t.string "video_time_string"
    t.string "video_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "local_version"
    t.index ["platform_id"], name: "index_user_flows_on_platform_id"
    t.index ["product_id"], name: "index_user_flows_on_product_id"
  end

  add_foreign_key "user_flow_tags", "tags"
  add_foreign_key "user_flow_tags", "user_flows"
  add_foreign_key "user_flows", "platforms"
  add_foreign_key "user_flows", "products"
end
