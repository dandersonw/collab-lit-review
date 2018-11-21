defmodule CollabLitReview.ReviewsTest do
  use CollabLitReview.DataCase

  alias CollabLitReview.Reviews

  describe "reviews" do
    alias CollabLitReview.Reviews.Review

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def review_fixture(attrs \\ %{}) do
      {:ok, review} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reviews.create_review()

      review
    end

    test "list_reviews/0 returns all reviews" do
      review = review_fixture()
      assert Reviews.list_reviews() == [review]
    end

    test "get_review!/1 returns the review with given id" do
      review = review_fixture()
      assert Reviews.get_review!(review.id) == review
    end

    test "create_review/1 with valid data creates a review" do
      assert {:ok, %Review{} = review} = Reviews.create_review(@valid_attrs)
      assert review.title == "some title"
    end

    test "create_review/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_review(@invalid_attrs)
    end

    test "update_review/2 with valid data updates the review" do
      review = review_fixture()
      assert {:ok, %Review{} = review} = Reviews.update_review(review, @update_attrs)
      assert review.title == "some updated title"
    end

    test "update_review/2 with invalid data returns error changeset" do
      review = review_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.update_review(review, @invalid_attrs)
      assert review == Reviews.get_review!(review.id)
    end

    test "delete_review/1 deletes the review" do
      review = review_fixture()
      assert {:ok, %Review{}} = Reviews.delete_review(review)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_review!(review.id) end
    end

    test "change_review/1 returns a review changeset" do
      review = review_fixture()
      assert %Ecto.Changeset{} = Reviews.change_review(review)
    end
  end

  describe "swimlanes" do
    alias CollabLitReview.Reviews.Swimlane

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def swimlane_fixture(attrs \\ %{}) do
      {:ok, swimlane} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reviews.create_swimlane()

      swimlane
    end

    test "list_swimlanes/0 returns all swimlanes" do
      swimlane = swimlane_fixture()
      assert Reviews.list_swimlanes() == [swimlane]
    end

    test "get_swimlane!/1 returns the swimlane with given id" do
      swimlane = swimlane_fixture()
      assert Reviews.get_swimlane!(swimlane.id) == swimlane
    end

    test "create_swimlane/1 with valid data creates a swimlane" do
      assert {:ok, %Swimlane{} = swimlane} = Reviews.create_swimlane(@valid_attrs)
      assert swimlane.name == "some name"
    end

    test "create_swimlane/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_swimlane(@invalid_attrs)
    end

    test "update_swimlane/2 with valid data updates the swimlane" do
      swimlane = swimlane_fixture()
      assert {:ok, %Swimlane{} = swimlane} = Reviews.update_swimlane(swimlane, @update_attrs)
      assert swimlane.name == "some updated name"
    end

    test "update_swimlane/2 with invalid data returns error changeset" do
      swimlane = swimlane_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.update_swimlane(swimlane, @invalid_attrs)
      assert swimlane == Reviews.get_swimlane!(swimlane.id)
    end

    test "delete_swimlane/1 deletes the swimlane" do
      swimlane = swimlane_fixture()
      assert {:ok, %Swimlane{}} = Reviews.delete_swimlane(swimlane)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_swimlane!(swimlane.id) end
    end

    test "change_swimlane/1 returns a swimlane changeset" do
      swimlane = swimlane_fixture()
      assert %Ecto.Changeset{} = Reviews.change_swimlane(swimlane)
    end
  end

  describe "buckets" do
    alias CollabLitReview.Reviews.Bucket

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def bucket_fixture(attrs \\ %{}) do
      {:ok, bucket} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reviews.create_bucket()

      bucket
    end

    test "list_buckets/0 returns all buckets" do
      bucket = bucket_fixture()
      assert Reviews.list_buckets() == [bucket]
    end

    test "get_bucket!/1 returns the bucket with given id" do
      bucket = bucket_fixture()
      assert Reviews.get_bucket!(bucket.id) == bucket
    end

    test "create_bucket/1 with valid data creates a bucket" do
      assert {:ok, %Bucket{} = bucket} = Reviews.create_bucket(@valid_attrs)
      assert bucket.name == "some name"
    end

    test "create_bucket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_bucket(@invalid_attrs)
    end

    test "update_bucket/2 with valid data updates the bucket" do
      bucket = bucket_fixture()
      assert {:ok, %Bucket{} = bucket} = Reviews.update_bucket(bucket, @update_attrs)
      assert bucket.name == "some updated name"
    end

    test "update_bucket/2 with invalid data returns error changeset" do
      bucket = bucket_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.update_bucket(bucket, @invalid_attrs)
      assert bucket == Reviews.get_bucket!(bucket.id)
    end

    test "delete_bucket/1 deletes the bucket" do
      bucket = bucket_fixture()
      assert {:ok, %Bucket{}} = Reviews.delete_bucket(bucket)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_bucket!(bucket.id) end
    end

    test "change_bucket/1 returns a bucket changeset" do
      bucket = bucket_fixture()
      assert %Ecto.Changeset{} = Reviews.change_bucket(bucket)
    end
  end

  describe "discoveries" do
    alias CollabLitReview.Reviews.Discovery

    @valid_attrs %{type: "some type"}
    @update_attrs %{type: "some updated type"}
    @invalid_attrs %{type: nil}

    def discovery_fixture(attrs \\ %{}) do
      {:ok, discovery} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reviews.create_discovery()

      discovery
    end

    test "list_discoveries/0 returns all discoveries" do
      discovery = discovery_fixture()
      assert Reviews.list_discoveries() == [discovery]
    end

    test "get_discovery!/1 returns the discovery with given id" do
      discovery = discovery_fixture()
      assert Reviews.get_discovery!(discovery.id) == discovery
    end

    test "create_discovery/1 with valid data creates a discovery" do
      assert {:ok, %Discovery{} = discovery} = Reviews.create_discovery(@valid_attrs)
      assert discovery.type == "some type"
    end

    test "create_discovery/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reviews.create_discovery(@invalid_attrs)
    end

    test "update_discovery/2 with valid data updates the discovery" do
      discovery = discovery_fixture()
      assert {:ok, %Discovery{} = discovery} = Reviews.update_discovery(discovery, @update_attrs)
      assert discovery.type == "some updated type"
    end

    test "update_discovery/2 with invalid data returns error changeset" do
      discovery = discovery_fixture()
      assert {:error, %Ecto.Changeset{}} = Reviews.update_discovery(discovery, @invalid_attrs)
      assert discovery == Reviews.get_discovery!(discovery.id)
    end

    test "delete_discovery/1 deletes the discovery" do
      discovery = discovery_fixture()
      assert {:ok, %Discovery{}} = Reviews.delete_discovery(discovery)
      assert_raise Ecto.NoResultsError, fn -> Reviews.get_discovery!(discovery.id) end
    end

    test "change_discovery/1 returns a discovery changeset" do
      discovery = discovery_fixture()
      assert %Ecto.Changeset{} = Reviews.change_discovery(discovery)
    end
  end
end
