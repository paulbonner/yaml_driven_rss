# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rss_test_harness_session',
  :secret      => 'f412dcb112890d26fe017e49dd759a45ea06ae3d81a8e8bc5a3b6ae2d8622d0f7651677c51a61ff339c554e5d2b86e0e54642249aba08a0ce0c0a35e31741c85'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
