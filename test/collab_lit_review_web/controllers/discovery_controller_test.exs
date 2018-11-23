defmodule CollabLitReviewWeb.DiscoveryControllerTest do
  use CollabLitReviewWeb.ConnCase

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Discovery

  @create_attrs %{
    type: "some type"
  }
  @update_attrs %{
    type: "some updated type"
  }
  @invalid_attrs %{type: nil}

  def fixture(:discovery) do
    {:ok, discovery} = Reviews.create_discovery(@create_attrs)
    discovery
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all discoveries", %{conn: conn} do
      conn = get(conn, Routes.discovery_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create discovery" do
    test "renders discovery when data is valid", %{conn: conn} do
      conn = post(conn, Routes.discovery_path(conn, :create), discovery: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.discovery_path(conn, :show, id))

      assert %{
               "id" => id,
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.discovery_path(conn, :create), discovery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update discovery" do
    setup [:create_discovery]

    test "renders discovery when data is valid", %{conn: conn, discovery: %Discovery{id: id} = discovery} do
      conn = put(conn, Routes.discovery_path(conn, :update, discovery), discovery: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.discovery_path(conn, :show, id))

      assert %{
               "id" => id,
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, discovery: discovery} do
      conn = put(conn, Routes.discovery_path(conn, :update, discovery), discovery: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete discovery" do
    setup [:create_discovery]

    test "deletes chosen discovery", %{conn: conn, discovery: discovery} do
      conn = delete(conn, Routes.discovery_path(conn, :delete, discovery))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.discovery_path(conn, :show, discovery))
      end
    end
  end

  defp create_discovery(_) do
    discovery = fixture(:discovery)
    {:ok, discovery: discovery}
  end
end
