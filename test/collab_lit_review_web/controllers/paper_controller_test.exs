defmodule CollabLitReviewWeb.PaperControllerTest do
  use CollabLitReviewWeb.ConnCase

  alias CollabLitReview.S2
  alias CollabLitReview.S2.Paper

  @create_attrs %{
    abstract: "some abstract",
    s2_id: 42,
    title: "some title"
  }
  @update_attrs %{
    abstract: "some updated abstract",
    s2_id: 43,
    title: "some updated title"
  }
  @invalid_attrs %{abstract: nil, s2_id: nil, title: nil}

  def fixture(:paper) do
    {:ok, paper} = S2.create_paper(@create_attrs)
    paper
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all papers", %{conn: conn} do
      conn = get(conn, Routes.paper_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create paper" do
    test "renders paper when data is valid", %{conn: conn} do
      conn = post(conn, Routes.paper_path(conn, :create), paper: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.paper_path(conn, :show, id))

      assert %{
               "id" => id,
               "abstract" => "some abstract",
               "s2_id" => 42,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.paper_path(conn, :create), paper: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update paper" do
    setup [:create_paper]

    test "renders paper when data is valid", %{conn: conn, paper: %Paper{id: id} = paper} do
      conn = put(conn, Routes.paper_path(conn, :update, paper), paper: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.paper_path(conn, :show, id))

      assert %{
               "id" => id,
               "abstract" => "some updated abstract",
               "s2_id" => 43,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, paper: paper} do
      conn = put(conn, Routes.paper_path(conn, :update, paper), paper: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete paper" do
    setup [:create_paper]

    test "deletes chosen paper", %{conn: conn, paper: paper} do
      conn = delete(conn, Routes.paper_path(conn, :delete, paper))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.paper_path(conn, :show, paper))
      end
    end
  end

  defp create_paper(_) do
    paper = fixture(:paper)
    {:ok, paper: paper}
  end
end
