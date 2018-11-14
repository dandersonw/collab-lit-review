defmodule CollabLitReviewWeb.AuthorView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.AuthorView

  def render("index.json", %{authors: authors}) do
    %{data: render_many(authors, AuthorView, "author.json")}
  end

  def render("show.json", %{author: author}) do
    %{data: render_one(author, AuthorView, "author.json")}
  end

  def render("author.json", %{author: author}) do
    %{id: author.id,
      s2_id: author.s2_id,
      name: author.name}
  end
end
