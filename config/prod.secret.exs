use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :pokedex_api, PokedexApi.Endpoint,
  secret_key_base: "DcPGtoHWRjgPeU0gwR0uCUwdnP2mGT9VdAi4TYe/hAi/Hxbc9r3HQgj0bk741ECB"

# Configure your database
config :pokedex_api, PokedexApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "pokedex_api_prod",
  pool_size: 20
