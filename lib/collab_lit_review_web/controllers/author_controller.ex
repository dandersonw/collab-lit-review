defmodule CollabLitReviewWeb.AuthorController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.S2
  alias CollabLitReview.S2.Author

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    authors = S2.list_authors()
    render(conn, "index.json", authors: authors)
  end

  def create(conn, %{"author" => author_params}) do
    with {:ok, %Author{} = author} <- S2.create_author(author_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.author_path(conn, :show, author))
      |> render("show.json", author: author)
    end
  end

  def show(conn, %{"id" => id}) do
    author = S2.get_author!(id)
    render(conn, "show.json", author: author)
  end

end
