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

ActiveRecord::Schema.define(version: 20170209222340) do

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "courses_departments", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "department_id"
    t.index ["course_id", "department_id"], name: "index_courses_departments_on_course_id_and_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "modules_users", id: false, force: :cascade do |t|
    t.integer "uni_module__id"
    t.integer "user_id"
    t.index ["uni_module__id", "user_id"], name: "index_modules_users_on_uni_module__id_and_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.string   "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_uni_modules", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "uni_module_id"
    t.index ["tag_id", "uni_module_id"], name: "index_tags_uni_modules_on_tag_id_and_uni_module_id"
  end

  create_table "uni_modules", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "description"
    t.string   "lecturers"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "username"
    t.string   "password_digest"
    t.integer  "user_level"
    t.boolean  "entered_before"
    t.integer  "year_of_study"
    t.string   "course_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
