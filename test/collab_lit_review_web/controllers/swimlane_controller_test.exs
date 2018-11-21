defmodule CollabLitReviewWeb.SwimlaneControllerTest do
  use CollabLitReviewWeb.ConnCase

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Swimlane

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:swimlane) do
    {:ok, swimlane} = Reviews.create_swimlane(@create_attrs)
    swimlane
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all swimlanes", %{conn: conn} do
      conn = get(conn, Routes.swimlane_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create swimlane" do
    test "renders swimlane when data is valid", %{conn: conn} do
      conn = post(conn, Routes.swimlane_path(conn, :create), swimlane: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.swimlane_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.swimlane_path(conn, :create), swimlane: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update swimlane" do
    setup [:create_swimlane]

    test "renders swimlane when data is valid", %{conn: conn, swimlane: %Swimlane{id: id} = swimlane} do
      conn = put(conn, Routes.swimlane_path(conn, :update, swimlane), swimlane: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.swimlane_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, swimlane: swimlane} do
      conn = put(conn, Routes.swimlane_path(conn, :update, swimlane), swimlane: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete swimlane" do
    setup [:create_swimlane]

    test "deletes chosen swimlane", %{conn: conn, swimlane: swimlane} do
      conn = delete(conn, Routes.swimlane_path(conn, :delete, swimlane))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.swimlane_path(conn, :show, swimlane))
      end
    end
  end

  defp create_swimlane(_) do
    swimlane = fixture(:swimlane)
    {:ok, swimlane: swimlane}
  end
end
