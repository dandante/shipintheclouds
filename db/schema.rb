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

ActiveRecord::Schema.define(:version => 20101221225307) do

  create_table "songs", :force => true do |t|
    t.text    "uuid"
    t.text    "album"
    t.text    "artist"
    t.text    "comments"
    t.text    "genre"
    t.text    "genre_s"
    t.integer "length"
    t.text    "title"
    t.integer "tracknum"
    t.integer "year"
    t.text    "file"
    t.integer "indexed_at"
    t.boolean "hidden"
    t.text    "album_c"
    t.text    "artist_c"
    t.text    "comments_c"
    t.text    "genre_c"
    t.text    "genre_s_c"
    t.text    "title_c"
    t.text    "file_c"
  end

  create_table "songs_import", :id => false, :force => true do |t|
    t.text    "uuid"
    t.text    "album"
    t.text    "artist"
    t.text    "comments"
    t.text    "genre"
    t.text    "genre_s"
    t.integer "length"
    t.text    "title"
    t.integer "tracknum"
    t.integer "year"
    t.text    "file"
    t.integer "indexed_at"
  end

end
