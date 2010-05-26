class Album < ActiveRecord::Base
  
  has_many :songs, :dependent => :destroy do
    
    def create(args)
      args.merge!({:artist_id => proxy_owner.artist_id})
      super(args)
    end
    
  end
  
end
