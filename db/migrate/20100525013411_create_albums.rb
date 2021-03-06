class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.integer :artist_id
      t.string :name
      t.date :published_at
    end
  end

  def self.down
    drop_table :albums
  end
end
