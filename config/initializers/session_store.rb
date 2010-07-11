# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_twiliotest_session',
  :secret      => '782b3fa3ee4415c8624a2677de4440f1d36d2deec99a76818cb78b9a7d1148de2a4b691dcbdaa6aefc7bc874d52c23a5b1b48618272b6ff9798368614e19d002'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
