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

ActiveRecord::Schema.define(version: 2021_04_23_144837) do

  create_table "platforms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.bigint "product_id", null: false
    t.bigint "platform_id", null: false
    t.string "path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_screen_shots_on_platform_id"
    t.index ["product_id"], name: "index_screen_shots_on_product_id"
  end

  create_table "tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.boolean "IsFlowTag"
    t.string "isTop"
    t.string "isRecommend"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "icon_path"
    t.string "version"
    t.string "video_time_string"
    t.string "video_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["platform_id"], name: "index_user_flows_on_platform_id"
    t.index ["product_id"], name: "index_user_flows_on_product_id"
  end

  add_foreign_key "screen_shot_tags", "screen_shots"
  add_foreign_key "screen_shot_tags", "tags"
  add_foreign_key "screen_shots", "platforms"
  add_foreign_key "screen_shots", "products"
  add_foreign_key "user_flow_tags", "tags"
  add_foreign_key "user_flow_tags", "user_flows"
  add_foreign_key "user_flows", "platforms"
  add_foreign_key "user_flows", "products"
end
