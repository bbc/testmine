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

ActiveRecord::Schema.define(version: 20170627190941) do

  create_table "results", force: :cascade do |t|
    t.integer  "test_definition_id", limit: 4
    t.integer  "run_id",             limit: 4
    t.integer  "parent_id",          limit: 4
    t.integer  "value",              limit: 4
    t.string   "status",             limit: 255
    t.text     "output",             limit: 65535
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["parent_id"], name: "index_results_on_parent_id", using: :btree
  add_index "results", ["run_id", "test_definition_id"], name: "index_results_on_run_id_and_test_definition_id", using: :btree
  add_index "results", ["run_id"], name: "index_results_on_run_id", using: :btree
  add_index "results", ["test_definition_id"], name: "index_results_on_test_definition_id", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "world_id",    limit: 4
    t.string   "owner",       limit: 255
    t.integer  "hive_job_id", limit: 4
    t.string   "target",      limit: 255
    t.string   "status",      limit: 255
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "runs", ["hive_job_id"], name: "index_runs_on_hive_job_id", using: :btree
  add_index "runs", ["target"], name: "index_runs_on_target", using: :btree
  add_index "runs", ["world_id"], name: "index_runs_on_world_id", using: :btree

  create_table "suites", force: :cascade do |t|
    t.string   "project",       limit: 255
    t.string   "name",          limit: 255
    t.string   "runner",        limit: 255
    t.string   "description",   limit: 255
    t.text     "documentation", limit: 65535
    t.string   "url",           limit: 255
    t.string   "repo",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suites", ["project", "name"], name: "index_suites_on_project_and_name", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "test_definitions", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "node_type",   limit: 255
    t.text     "description", limit: 65535
    t.string   "file",        limit: 255
    t.integer  "line",        limit: 4
    t.integer  "parent_id",   limit: 4
    t.integer  "suite_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "test_definitions", ["name", "suite_id", "file", "parent_id"], name: "lookup", using: :btree
  add_index "test_definitions", ["parent_id"], name: "index_test_definitions_on_parent_id", using: :btree
  add_index "test_definitions", ["suite_id"], name: "index_test_definitions_on_suite_id", using: :btree

  create_table "worlds", force: :cascade do |t|
    t.string   "type",        limit: 255
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.string   "project",     limit: 255
    t.string   "component",   limit: 255
    t.string   "version",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "worlds", ["project", "component", "version"], name: "index_worlds_on_project_and_component_and_version", using: :btree
  add_index "worlds", ["project", "component"], name: "index_worlds_on_project_and_component", using: :btree
  add_index "worlds", ["project"], name: "index_worlds_on_project", using: :btree

end
