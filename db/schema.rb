# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_05_31_063919) do

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

  create_table "screen_shot_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "screen_shot_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["screen_shot_id"], name: "index_screen_shot_tags_on_screen_shot_id"
    t.index ["tag_id"], name: "index_screen_shot_tags_on_tag_id"
  end

  create_table "screen_shots", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_flow_id", null: false
    t.string "path", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "tag_id"
    t.index ["tag_id"], name: "index_screen_shots_on_tag_id"
    t.index ["user_flow_id"], name: "index_screen_shots_on_user_flow_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "tag_type"
    t.string "isTop", limit: 255
    t.string "isRecommend", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", limit: 255
    t.string "slug", limit: 255, null: false
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
    t.string "bg_color", limit: 255
    t.string "thumbnail_path", limit: 255
    t.string "version", limit: 255
    t.string "video_time_string", limit: 255
    t.string "video_path", limit: 255
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "local_version"
    t.bigint "tag_id"
    t.index ["platform_id"], name: "index_user_flows_on_platform_id"
    t.index ["product_id"], name: "index_user_flows_on_product_id"
    t.index ["tag_id"], name: "fk_rails_903d4f1e72"
  end

  add_foreign_key "screen_shot_tags", "screen_shots"
  add_foreign_key "screen_shot_tags", "tags"
  add_foreign_key "screen_shots", "tags"
  add_foreign_key "screen_shots", "user_flows", name: "screen_shots_ibfk_1"
  add_foreign_key "user_flow_tags", "tags"
  add_foreign_key "user_flow_tags", "user_flows"
  add_foreign_key "user_flows", "platforms"
  add_foreign_key "user_flows", "products"
  add_foreign_key "user_flows", "tags"
end
