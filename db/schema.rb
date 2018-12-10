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

ActiveRecord::Schema.define(version: 20160216102230) do

  create_table "results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "test_definition_id"
    t.integer  "run_id"
    t.integer  "parent_id"
    t.integer  "value"
    t.string   "status"
    t.text     "output",             limit: 65535
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "index_results_on_parent_id", using: :btree
    t.index ["run_id", "test_definition_id"], name: "index_results_on_run_id_and_test_definition_id", using: :btree
    t.index ["run_id"], name: "index_results_on_run_id", using: :btree
    t.index ["test_definition_id"], name: "index_results_on_test_definition_id", using: :btree
  end

  create_table "runs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "world_id"
    t.string   "owner"
    t.integer  "hive_job_id"
    t.string   "target"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["hive_job_id"], name: "index_runs_on_hive_job_id", using: :btree
    t.index ["target"], name: "index_runs_on_target", using: :btree
    t.index ["world_id"], name: "index_runs_on_world_id", using: :btree
  end

  create_table "suites", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "project"
    t.string   "name"
    t.string   "runner"
    t.string   "description"
    t.text     "documentation", limit: 65535
    t.string   "url"
    t.string   "repo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project", "name"], name: "index_suites_on_project_and_name", using: :btree
  end

  create_table "taggings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  end

  create_table "tags", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
  end

  create_table "test_definitions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "name"
    t.string   "node_type"
    t.text     "description", limit: 65535
    t.string   "file"
    t.integer  "line"
    t.integer  "parent_id"
    t.integer  "suite_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "suite_id", "file", "parent_id"], name: "lookup", using: :btree
    t.index ["parent_id"], name: "index_test_definitions_on_parent_id", using: :btree
    t.index ["suite_id"], name: "index_test_definitions_on_suite_id", using: :btree
  end

  create_table "worlds", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string   "type"
    t.string   "name"
    t.text     "description", limit: 65535
    t.string   "project"
    t.string   "component"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["project", "component", "version"], name: "index_worlds_on_project_and_component_and_version", using: :btree
    t.index ["project", "component"], name: "index_worlds_on_project_and_component", using: :btree
    t.index ["project"], name: "index_worlds_on_project", using: :btree
  end

end
