# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_shipintheclouds_session',
  :secret      => '7857650f6784f2a106981f4c0992a77803fa5cd19b1ef40ee2b756be98508611b1e6df7c95ff50bedc7bcb273a403d32b42f5ecff351044cf68d0497c1abca96'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
