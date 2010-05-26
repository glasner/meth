class Song < ActiveRecord::Base
  
  belongs_to :artist
  
  belongs_to :album
  
  has_many :snippets, :class_name => 'Song::Snippet', :dependent => :delete_all
  
  
  named_scope :pending, :conditions =>'snippets_created_at IS NULL OR pending_snippet_count > 0'
  
  
  #= Fetching lyrics from LyricWiki
  
  def create_snippets
    lyrics.split("\n").each do |line| 
      create_snippet(line) if Song::Snippet.create?(line) 
    end
    self.snippets_created_at = Time.now
    save
  end
  
  def create_snippet(line)
    snippets.create(:body => line) 
    increment(:pending_snippet_count)
  end
  
  # returns lyrics as string
  def lyrics
    require 'faraday'
    url = URI.escape("http://lyrics.wikia.com/#{artist.name.gsub(' ','_')}:#{name.gsub(' ','_')}")
    response = Faraday.get(url)
    body = response.body.gsub("<br />","\n")
    doc = Nokogiri::HTML.parse(body)
    lyrics = doc.css('.lyricbox').text.gsub(/Send .+ Ringtone to your Cell/,'').strip
  end
  
  #= Returns a random pending snippet
  
  def random_snippet
    create_snippets if snippets_created_at.nil?
    return nil if pending_snippet_count.nil? or pending_snippet_count.zero?
    ids = snippets.pending.map { |snippet| snippet.id  }
    random_id = ids[rand(ids.length)]
    snippets.pending.find(random_id)
  end
  
  
  
end
