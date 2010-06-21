# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_db:migrate_session',
  :secret      => '37b6a83b8c40a471ab15cd97ca8dd8d92ac16714a421a223d062ab26a14469c79f74d92cf6ce5545555f9ee722cf63921992b2f1c717d694f6b5dd2a82274ece'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
