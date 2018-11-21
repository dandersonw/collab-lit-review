defmodule CollabLitReviewWeb.BucketController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Bucket

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    buckets = Reviews.list_buckets()
    render(conn, "index.json", buckets: buckets)
  end

  def create(conn, %{"bucket" => bucket_params}) do
    with {:ok, %Bucket{} = bucket} <- Reviews.create_bucket(bucket_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.bucket_path(conn, :show, bucket))
      |> render("show.json", bucket: bucket)
    end
  end

  def show(conn, %{"id" => id}) do
    bucket = Reviews.get_bucket!(id)
    render(conn, "show.json", bucket: bucket)
  end

  def update(conn, %{"id" => id, "bucket" => bucket_params}) do
    bucket = Reviews.get_bucket!(id)

    with {:ok, %Bucket{} = bucket} <- Reviews.update_bucket(bucket, bucket_params) do
      render(conn, "show.json", bucket: bucket)
    end
  end

  def delete(conn, %{"id" => id}) do
    bucket = Reviews.get_bucket!(id)

    with {:ok, %Bucket{}} <- Reviews.delete_bucket(bucket) do
      send_resp(conn, :no_content, "")
    end
  end
end
