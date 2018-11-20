# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :collab_lit_review,
  ecto_repos: [CollabLitReview.Repo]

# Configures the endpoint
config :collab_lit_review, CollabLitReviewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SA/WSvBCRax9vVmcR/BeTm2jUPZlvN9aKHoO/8ftA4EYmNuftY8Yv63cr6Qnixce",
  render_errors: [view: CollabLitReviewWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CollabLitReview.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Jason
config :ecto, :json_library, Jason

# Configure Ueberauth for login through external sites
config :ueberauth, Ueberauth,
  providers: [
    #google: {Ueberauth.Strategy.Google, [default_scope: "emails profile plus.me"]}
    google: {Ueberauth.Strategy.Google, [default_scope: "profile"]}
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "827372302923-j1opapmdo4etvufs3vdf6e90enkfihfc.apps.googleusercontent.com",
  client_secret: "--"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
