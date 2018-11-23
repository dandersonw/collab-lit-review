defmodule CollabLitReviewWeb.DiscoveryController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.Reviews
  alias CollabLitReview.Reviews.Discovery

  action_fallback CollabLitReviewWeb.FallbackController

  # def index(conn, _params) do
  #   discoveries = Reviews.list_discoveries()
  #   render(conn, "index.json", discoveries: discoveries)
  # end

  # def create(conn, %{"discovery" => discovery_params}) do
  #   with {:ok, %Discovery{} = discovery} <- Reviews.create_discovery(discovery_params) do
  #     conn
  #     |> put_status(:created)
  #     |> put_resp_header("location", Routes.discovery_path(conn, :show, discovery))
  #     |> render("show.json", discovery: discovery)
  #   end
  # end

  def show(conn, %{"id" => id}) do
    discovery = Reviews.get_discovery!(id)
    render(conn, "show.json", discovery: discovery)
  end

  # def update(conn, %{"id" => id, "discovery" => discovery_params}) do
  #   discovery = Reviews.get_discovery!(id)

  #   with {:ok, %Discovery{} = discovery} <- Reviews.update_discovery(discovery, discovery_params) do
  #     render(conn, "show.json", discovery: discovery)
  #   end
  # end

  def delete(conn, %{"id" => id}) do
    discovery = Reviews.get_discovery!(id)

    with {:ok, %Discovery{}} <- Reviews.delete_discovery(discovery) do
      send_resp(conn, :no_content, "")
    end
  end
end
