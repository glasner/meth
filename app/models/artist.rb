class Artist < ActiveRecord::Base
  
  has_many :songs, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  
  after_create :fetch_albums_and_songs
  
  def fetch_albums_and_songs
    require 'faraday'
    url = "http://lyrics.wikia.com/api.php?func=getArtist&artist=#{name.gsub(' ','_')}"
    response = Faraday.get(url)
    doc = Nokogiri::HTML.parse(response.body)
    doc.css('.albums > li').each do |li|
      @album = parse_album_from(li)
      parse_songs_from(li)
    end
  end
  
  def parse_album_from(li)
    text = li.css('a')[0].text
    match = text.match(/(.+)_\((\d+)\)/)
    match.nil? ? nil : albums.create(:name => match.to_a[1])
  end
  
  def parse_songs_from(li)
    li.css('.songs li a').each do |link|
      song = {:name => link.text}
      @album.nil? ? songs.create(song) : @album.songs.create(song)
    end
  end
  
  # Posting
  
  def self.post_random_snippets
    all.each { |artist| artist.post_random_snippet;sleep(2) }
  end
    
  # finds a Song w/ pending snippets and posts one
  def post_random_snippet
    song = random_song
    return nil if song.nil? # when no more songs
    snippet = song.random_snippet
    return post_random_snippet if snippet.nil? # will try to get another song    
    response = twitter.update(snippet.body) 
    if response
      snippet.update_attributes(:external_id => response['id'],:posted_at => response['created_at'])  
      song.decrement!(:pending_snippet_count)    
      p "#{name} >> #{snippet.body}"
    end
    
  end
  
  # returns random Song that still has pending snippets
  def random_song
    ids = songs.pending.map { |song| song.id  }
    return nil if ids.empty?
    random_id = ids[rand(ids.length)]
    songs.pending.find(random_id)
  end
  
  #= Twitter API
  
  #= API through OAuth
  
  # returns authorized TwitterOAuth::Client from given oauth hash
  def self.twitter(oauth)
    unless oauth.is_a?(Hash)
      oauth = {
        :token => oauth.token,
        :secret => oauth.secret
      }
    end    
    
    oauth.merge!({
      :consumer_key => ENV['TWITTER_KEY'],
      :consumer_secret => ENV['TWITTER_SECRET'],
    })      
    TwitterOAuth::Client.new(oauth)
  end
  
  def twitter
    credentials = {
      :token => oauth_token,
      :secret => oauth_secret
    }
    self.class.twitter(credentials)
  end
  
  #= Bios
  
  def update_description
    twitter.update_profile(:location => description)
  end
  
  def description
    "Classic #{name} ryhmes. One line at a time. Retweet to vote!"
  end
  
  
  
  
  
end
