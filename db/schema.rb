# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091004133605) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colours", :force => true do |t|
    t.integer  "palette_id"
    t.integer  "red"
    t.integer  "green"
    t.integer  "blue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "palettes", :force => true do |t|
    t.integer  "source_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sources", :force => true do |t|
    t.string   "name"
    t.integer  "category_id"
    t.string   "page_url"
    t.string   "image_regex"
    t.integer  "last_palette_hash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url_prefix"
  end

end
