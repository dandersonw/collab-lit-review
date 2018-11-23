defmodule CollabLitReviewWeb.ReviewView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.ReviewView

  def render("index.json", %{reviews: reviews}) do
    %{data: render_many(reviews, ReviewView, "review.json")}
  end

  def render("show.json", %{review: review}) do
    %{data: render_one(review, ReviewView, "review.json")}
  end

  def render("review.json", %{review: review}) do
    %{id: review.id,
      title: review.title}
  end
end
