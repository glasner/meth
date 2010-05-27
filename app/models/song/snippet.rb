class Song::Snippet < ActiveRecord::Base
  
  belongs_to :song
  
  named_scope :pending, :conditions => 'posted_at IS NULL'
  
  # returns true if snippet should be created for given line
  def self.create?(line)
    line.strip!
    line.match(/\(.+\)/).nil? and
    line.match(/\[.+\]/).nil? and
    line.match(/Chorus/).nil? and
    !line.empty? and
    (line.split(' ').size > 4)
  end
  
  # rerun existing snippets back through create? filter
  def self.filter!
    all.each do |snippet|
      snippet.destroy unless snippet.posted_at.nil? and Song::Snippet.create?(snippet.body)
    end
  end
  
  
end
 