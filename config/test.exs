use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :collab_lit_review, CollabLitReviewWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# taken mutatis mutandi from the course notes
get_secret = fn name ->
  base = Path.expand("~/.config/collab_lit_review")
  File.mkdir_p!(base)
  path = Path.join(base, name)
  unless File.exists?(path) do
    secret = Base.encode16(:crypto.strong_rand_bytes(32))
    File.write!(path, secret)
  end
  String.trim(File.read!(path))
end

# Configure your database
config :collab_lit_review, TaskTracker.Repo,
  username: "collab_lit_review",
  password: get_secret.("db_pass"),
  database: "collab_lit_review_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
