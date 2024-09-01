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

ActiveRecord::Schema[7.2].define(version: 2024_09_01_061019) do
  create_table "activities", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "event", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_activities_on_created_at"
    t.index ["description"], name: "index_activities_on_description"
    t.index ["event"], name: "index_activities_on_event"
    t.index ["updated_at"], name: "index_activities_on_updated_at"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "image", limit: 191
    t.string "slug", null: false
    t.string "title", null: false
    t.text "description"
    t.text "content", size: :long
    t.text "categories", size: :long
    t.text "tags", size: :long
    t.integer "total_viewer", default: 0
    t.integer "total_comment", default: 0
    t.integer "status", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_articles_on_created_at"
    t.index ["image"], name: "index_articles_on_image"
    t.index ["slug"], name: "index_articles_on_slug"
    t.index ["status"], name: "index_articles_on_status"
    t.index ["title"], name: "index_articles_on_title"
    t.index ["total_comment"], name: "index_articles_on_total_comment"
    t.index ["total_viewer"], name: "index_articles_on_total_viewer"
    t.index ["updated_at"], name: "index_articles_on_updated_at"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "parent_id"
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.string "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_comments_on_article_id"
    t.index ["created_at"], name: "index_comments_on_created_at"
    t.index ["parent_id"], name: "index_comments_on_parent_id"
    t.index ["updated_at"], name: "index_comments_on_updated_at"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "subject", null: false
    t.string "message", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_notifications_on_created_at"
    t.index ["message"], name: "index_notifications_on_message"
    t.index ["subject"], name: "index_notifications_on_subject"
    t.index ["updated_at"], name: "index_notifications_on_updated_at"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "email", limit: 191, null: false
    t.string "phone", limit: 20
    t.string "password_digest"
    t.string "image", limit: 191
    t.string "first_name", limit: 64
    t.string "last_name", limit: 191
    t.string "gender", limit: 2
    t.string "country", limit: 191
    t.string "job_title", limit: 191
    t.string "facebook"
    t.string "instagram"
    t.string "twitter"
    t.string "linked_in"
    t.text "address"
    t.text "about_me"
    t.string "reset_token", limit: 36
    t.string "confirm_token", limit: 36
    t.integer "confirmed", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirm_token"], name: "index_users_on_confirm_token"
    t.index ["confirmed"], name: "index_users_on_confirmed"
    t.index ["country"], name: "index_users_on_country"
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["facebook"], name: "index_users_on_facebook"
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["gender"], name: "index_users_on_gender"
    t.index ["image"], name: "index_users_on_image"
    t.index ["instagram"], name: "index_users_on_instagram"
    t.index ["job_title"], name: "index_users_on_job_title"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["linked_in"], name: "index_users_on_linked_in"
    t.index ["password_digest"], name: "index_users_on_password_digest"
    t.index ["phone"], name: "index_users_on_phone"
    t.index ["reset_token"], name: "index_users_on_reset_token"
    t.index ["twitter"], name: "index_users_on_twitter"
    t.index ["updated_at"], name: "index_users_on_updated_at"
  end

  create_table "viewers", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "user_id", null: false
    t.integer "status", limit: 2, default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_viewers_on_article_id"
    t.index ["created_at"], name: "index_viewers_on_created_at"
    t.index ["status"], name: "index_viewers_on_status"
    t.index ["updated_at"], name: "index_viewers_on_updated_at"
    t.index ["user_id"], name: "index_viewers_on_user_id"
  end

  add_foreign_key "activities", "users"
  add_foreign_key "articles", "users"
  add_foreign_key "comments", "articles"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "viewers", "articles"
  add_foreign_key "viewers", "users"
end
