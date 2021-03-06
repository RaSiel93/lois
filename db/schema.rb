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

ActiveRecord::Schema.define(version: 20140517101515) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "basic_predicates", force: true do |t|
    t.integer "rule_id"
    t.string  "name"
  end

  create_table "constants", force: true do |t|
    t.integer "fact_id"
    t.string  "name"
  end

  create_table "facts", force: true do |t|
    t.string "name"
  end

  create_table "parameters", force: true do |t|
    t.integer "basic_predicate_id"
    t.string  "name"
  end

  create_table "rules", force: true do |t|
  end

end
