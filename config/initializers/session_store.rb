# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_meth_session',
  :secret      => '51ef818a7ec637f4f545e7f18b42992c2427c6ad9e51bcb65b7982c5111c43dd2c86684e8519d815355d4462ca84edf5f43fe6ac101023ac2e50a0a85b994cd5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
