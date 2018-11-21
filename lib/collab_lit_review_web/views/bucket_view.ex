defmodule CollabLitReviewWeb.BucketView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.BucketView

  def render("index.json", %{buckets: buckets}) do
    %{data: render_many(buckets, BucketView, "bucket.json")}
  end

  def render("show.json", %{bucket: bucket}) do
    %{data: render_one(bucket, BucketView, "bucket.json")}
  end

  def render("bucket.json", %{bucket: bucket}) do
    %{id: bucket.id,
      name: bucket.name}
  end
end
