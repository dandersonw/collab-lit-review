defmodule CollabLitReviewWeb.BucketControllerTest do
  use CollabLitReviewWeb.ConnCase

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Bucket

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:bucket) do
    {:ok, bucket} = Reviews.create_bucket(@create_attrs)
    bucket
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all buckets", %{conn: conn} do
      conn = get(conn, Routes.bucket_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create bucket" do
    test "renders bucket when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bucket_path(conn, :create), bucket: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.bucket_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bucket_path(conn, :create), bucket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update bucket" do
    setup [:create_bucket]

    test "renders bucket when data is valid", %{conn: conn, bucket: %Bucket{id: id} = bucket} do
      conn = put(conn, Routes.bucket_path(conn, :update, bucket), bucket: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.bucket_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, bucket: bucket} do
      conn = put(conn, Routes.bucket_path(conn, :update, bucket), bucket: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete bucket" do
    setup [:create_bucket]

    test "deletes chosen bucket", %{conn: conn, bucket: bucket} do
      conn = delete(conn, Routes.bucket_path(conn, :delete, bucket))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.bucket_path(conn, :show, bucket))
      end
    end
  end

  defp create_bucket(_) do
    bucket = fixture(:bucket)
    {:ok, bucket: bucket}
  end
end
