# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_retaste_me_session',
  :secret      => 'ba88fcb4578c290d69314e6b664b65fb0e3caf2ad8824adf30a5d7487cdb779d5e8a3a76de1b96730b5107c18c83d645939a244c3976290a547f000dcee7a397'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
