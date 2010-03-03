# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_eopas_session',
  :secret => '0b61e3bbe73b32ed8fe43f2c567439beccd93148706bf9dce08792fa93856a4c84b39eec5fdac65bf98394a2f2602ec4a831efc9a8120813c3d4ed8c6eda65c0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
