# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Although this is not needed for an api-only application, rails4
# requires secret_key_base or secret_token to be defined, otherwise an
# error is raised.
# Using secret_token for rails3 compatibility. Change to secret_key_base
# to avoid deprecation warning.
# Can be safely removed in a rails3 api-only application.
BpopApi::Application.config.secret_token = 'b61354d1632d90d79129bfb0fd1a5a6cfeabde259f20f910ee2899483f99a0bb4a750b0a96b45bcaec7d7d19a4802ed97e42908241b9e5447c073bd3d787a37f'
