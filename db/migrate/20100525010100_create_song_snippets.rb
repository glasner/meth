class CreateSongSnippets < ActiveRecord::Migration
  def self.up
    create_table :song_snippets do |t|
      t.integer :song_id
      t.integer :external_id
      t.string :body      
      t.datetime :posted_at
    end
    
    add_index :song_snippets, :song_id
    add_index :song_snippets, [:song_id,:posted_at]
    add_index :song_snippets, :posted_at
    
    execute "ALTER TABLE song_snippets CHANGE external_id external_id bigint(30) unsigned"
    
  end

  def self.down
    drop_table :song_snippets
  end
end
