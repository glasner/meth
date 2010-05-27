class Song::Snippet < ActiveRecord::Base
  
  belongs_to :song
  
  named_scope :pending, :conditions => 'posted_at IS NULL'
  
  def self.create?(line)
    line.strip!
    line.match(/\(.+\)/).nil? and
    line.match(/\[.+\]/).nil? and
    line.match(/Chorus/).nil? and
    !line.empty? and
    (line.split(' ').size > 4)
  end
  
  
end
 