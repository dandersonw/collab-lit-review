defmodule CollabLitReview.Repo do
  use Ecto.Repo,
    otp_app: :collab_lit_review,
    adapter: Ecto.Adapters.Postgres
end
