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

ActiveRecord::Schema.define(:version => 20100525013411) do

  create_table "albums", :force => true do |t|
    t.integer "artist_id"
    t.string  "name"
    t.date    "published_at"
  end

  create_table "artists", :force => true do |t|
    t.integer "song_count"
    t.integer "external_id",  :limit => 8
    t.string  "name"
    t.string  "screen_name"
    t.string  "oauth_token"
    t.string  "oauth_secret"
  end

  create_table "song_snippets", :force => true do |t|
    t.integer  "song_id"
    t.integer  "external_id", :limit => 8
    t.string   "body"
    t.datetime "posted_at"
  end

  add_index "song_snippets", ["posted_at"], :name => "index_song_snippets_on_posted_at"
  add_index "song_snippets", ["song_id", "posted_at"], :name => "index_song_snippets_on_song_id_and_posted_at"
  add_index "song_snippets", ["song_id"], :name => "index_song_snippets_on_song_id"

  create_table "songs", :force => true do |t|
    t.integer  "artist_id"
    t.integer  "album_id"
    t.integer  "pending_snippet_count"
    t.string   "name"
    t.datetime "snippets_created_at"
  end

  add_index "songs", ["artist_id"], :name => "index_songs_on_artist_id"

end
