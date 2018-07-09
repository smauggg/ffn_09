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

ActiveRecord::Schema.define(version: 20180709090810) do

  create_table "achievements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.date "received_day", null: false
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["team_id"], name: "index_achievements_on_team_id"
  end

  create_table "bets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.decimal "coin", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "match_id"
    t.integer "team"
    t.index ["match_id"], name: "index_bets_on_match_id"
    t.index ["user_id"], name: "index_bets_on_user_id"
  end

  create_table "ckeditor_assets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "data_file_name", null: false
    t.string "data_content_type"
    t.integer "data_file_size"
    t.string "type", limit: 30
    t.integer "width"
    t.integer "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_ckeditor_assets_on_type"
  end

  create_table "comments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "content"
    t.string "commentable_type"
    t.bigint "commentable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "continents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_continents_on_name"
  end

  create_table "countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "continent_id"
    t.index ["continent_id"], name: "index_countries_on_continent_id"
    t.index ["name"], name: "index_countries_on_name"
  end

  create_table "league_team_join_models", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "league_id", null: false
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_leagues_teams_on_league_id"
    t.index ["team_id"], name: "index_leagues_teams_on_team_id"
  end

  create_table "leagues", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.string "logo"
    t.index ["country_id"], name: "index_leagues_on_country_id"
  end

  create_table "matches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "team1_id", null: false
    t.integer "team2_id", null: false
    t.integer "score1"
    t.integer "score2"
    t.date "day", null: false
    t.time "start_time", null: false
    t.string "stadium"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "league_id"
    t.float "handicap", limit: 24, default: 0.0
    t.index ["league_id"], name: "index_matches_on_league_id"
  end

  create_table "news", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "header", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "header_img"
    t.string "main_content"
    t.index ["user_id"], name: "index_news_on_user_id"
  end

  create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.date "dob"
    t.string "position"
    t.integer "p_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.bigint "team_id"
    t.string "picture"
    t.index ["country_id"], name: "index_players_on_country_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "rankings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "team_id"
    t.integer "number_of_matches", default: 0
    t.integer "win", default: 0
    t.integer "draw", default: 0
    t.integer "lose", default: 0
    t.integer "number_of_goals", default: 0
    t.integer "score", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "league_id"
    t.index ["league_id"], name: "index_rankings_on_league_id"
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "city"
    t.string "stadium"
    t.string "president"
    t.string "coach"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.string "picture"
    t.text "description"
    t.string "logo"
    t.index ["country_id"], name: "index_teams_on_country_id"
  end

  create_table "transfers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date "transfer_day", null: false
    t.integer "from_team_id", null: false
    t.integer "to_team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "player_id"
    t.index ["player_id"], name: "index_transfers_on_player_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "address"
    t.integer "role", default: 0, null: false
    t.decimal "coin", precision: 10, scale: 2, default: "1000.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "achievements", "teams"
  add_foreign_key "bets", "matches"
  add_foreign_key "bets", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "countries", "continents"
  add_foreign_key "leagues", "countries"
  add_foreign_key "matches", "leagues"
  add_foreign_key "news", "users"
  add_foreign_key "players", "countries"
  add_foreign_key "players", "teams"
  add_foreign_key "rankings", "leagues"
  add_foreign_key "teams", "countries"
  add_foreign_key "transfers", "players"
end
