# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_the_colour_of_session',
  :secret      => 'd0b757309bd780ef07f447388041984dd3e5921112e6cdd15fbe990e7ea739fb8431c9b0ea415d87afefe6d28a9058f5f634387f11e3c2e7cd4df496b4ba2a52'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
