class ArtistsController < ApplicationController
  
  before_filter :set_consumer
  
  def new   
    set_consumer
    return redirect_to_twitter unless returning_from_twitter?    
    return render(:text => 'Not authorized <a href="/artists/new">Try again</a>') unless access_token_authorized?    
    merge_twitter_profile_with_artist_params    
    @artist = Artist.new(params[:artist])    
    render
  end
  
  
  

  def create
    @artist = Artist.create(params[:artist])
    return render(:text => 'Could not create artist. <a href="/artists/new">Try again</a>') unless @artist.id
    redirect_to '/artists/new'
  end
  
  private
  
  def set_consumer
    @consumer=OAuth::Consumer.new(ENV['TWITTER_KEY'],ENV['TWITTER_SECRET'], {
      :site=>'http://api.twitter.com'
    })
  end
  
  def returning_from_twitter?
    params.has_key?(:oauth_verifier)
  end
  
  # redirect to Twitter for OAuth
  def redirect_to_twitter
    @request_token = @consumer.get_request_token(:oauth_callback => ENV['DOMAIN'] + '/artists/new')
    
    session[:oauth] = {:request => {
      :token => @request_token.token,
      :token_secret => @request_token.secret
    }}
                                                               
    redirect_to @request_token.authorize_url
  end
  
  # called when redirected back from Twitter w/ OAuth token
  def merge_twitter_profile_with_artist_params
    params[:artist] = {} unless params[:artist]
    params[:artist].merge!({
      :name => @profile['name'].gsub(' Says',''),
      :external_id => @profile['id'],
      :screen_name => @profile['screen_name'],
      :oauth_token => access_token.token,
      :oauth_secret => access_token.secret 
    })
  end
  
  def access_token
    return @access_token unless @access_token.nil?
    @saved_request = session[:oauth][:request] 
    @request_token = OAuth::RequestToken.new(@consumer, @saved_request[:token], @saved_request[:token_secret])
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])    
  end
  
  def access_token_authorized?
    oauth_response = access_token.get('/account/verify_credentials.json')
    @profile = Yajl.load(oauth_response.body)
    oauth_response.class.eql?(Net::HTTPOK)
  end

end
