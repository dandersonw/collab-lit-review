defmodule CollabLitReviewWeb.ReviewView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.ReviewView
  alias CollabLitReview.Repo

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    review = Repo.preload(review, :collaborators)
    %{id: review.id,
      title: review.title,
      collaborators: Enum.map(review.collaborators, fn user -> %{id: user.id} end)}
  end
end
