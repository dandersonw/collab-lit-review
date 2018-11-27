defmodule CollabLitReviewWeb.ReviewController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Review
  alias CollabLitReview.Users
  alias CollabLitReview.Users.User

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    user = conn.assigns.current_user
    reviews = case user do
                nil -> []
                user -> Reviews.list_reviews(user)
              end
    render(conn, "index.json", reviews: reviews)
  end

  def create(conn, %{"title" => title, "user_id" => user_id}) do
    current_user = conn.assigns.current_user
    if current_user && current_user.id == user_id do # only the current user can create reviews in their name
      with {:ok, %Review{} = review} <- Reviews.create_review(current_user, title) do
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.review_path(conn, :show, review))
        |> render("show.json", review: review)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)
    render(conn, "show.json", review: review)
  end

  def update(conn, %{"new_user_id" => new_user_id, "id" => review_id}) do
    IO.puts "updated user"
    review = Reviews.get_review!(review_id);
    user = Users.get_user!(new_user_id);
    with {:ok, %Review{} = review} <- Reviews.add_collaborator_to_review(user, review) do
      render(conn, "show.json", review: review)
    end
  end

  def delete(conn, %{"id" => id}) do
    review = Reviews.get_review!(id)
    IO.puts "Deleting a review"
    IO.inspect review
    with {:ok, %Review{}} <- Reviews.delete_review(review) do
      send_resp(conn, :no_content, "")
    end
  end
end
