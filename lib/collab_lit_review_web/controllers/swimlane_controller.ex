defmodule CollabLitReviewWeb.SwimlaneController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Swimlane

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    swimlanes = Reviews.list_swimlanes()
    render(conn, "index.json", swimlanes: swimlanes)
  end

  def create(conn, %{"swimlane" => swimlane_params}) do
    with {:ok, %Swimlane{} = swimlane} <- Reviews.create_swimlane(swimlane_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.swimlane_path(conn, :show, swimlane))
      |> render("show.json", swimlane: swimlane)
    end
  end

  def show(conn, %{"id" => id}) do
    swimlane = Reviews.get_swimlane!(id)
    render(conn, "show.json", swimlane: swimlane)
  end

  def update(conn, %{"id" => id, "swimlane" => swimlane_params}) do
    swimlane = Reviews.get_swimlane!(id)

    with {:ok, %Swimlane{} = swimlane} <- Reviews.update_swimlane(swimlane, swimlane_params) do
      render(conn, "show.json", swimlane: swimlane)
    end
  end

  def delete(conn, %{"id" => id}) do
    swimlane = Reviews.get_swimlane!(id)

    with {:ok, %Swimlane{}} <- Reviews.delete_swimlane(swimlane) do
      send_resp(conn, :no_content, "")
    end
  end
end
