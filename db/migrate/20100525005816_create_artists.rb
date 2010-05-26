class CreateArtists < ActiveRecord::Migration
  def self.up
    create_table :artists do |t|
      t.integer :song_count
      t.integer :external_id
      t.string :name
      t.string :screen_name
      t.string :oauth_token
      t.string :oauth_secret
    end
    
    execute "ALTER TABLE artists CHANGE external_id external_id bigint(30) unsigned"
    
  end

  def self.down
    drop_table :artists
  end
end
