defmodule CollabLitReviewWeb.PageController do
  use CollabLitReviewWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      session: CollabLitReview.Users.session_from_user(conn.assigns.current_user),
    )
  end
end
