class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.integer :artist_id
      t.integer :album_id
      t.integer :pending_snippet_count
      t.string :name
      t.datetime :snippets_created_at
    end
    
    add_index :songs, :artist_id
    
    
  end

  def self.down
    drop_table :songs
  end
end
