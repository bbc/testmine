# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Testmine::Application.config.secret_key_base = ENV['RAILS_SECRET_KEY_BASE'] || 'b28ee70e95c8790954be8eb5d2bb743cccd95a2e1e759c18b493652312f8378fe0280f51313782683d036176147321bbe2310483863372c398b19991c0c256be' 
