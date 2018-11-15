defmodule CollabLitReviewWeb.PaperController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.S2
  alias CollabLitReview.S2.Paper

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    papers = S2.list_papers()
    render(conn, "index.json", papers: papers)
  end

  # Can cause something to be fetched.
  def create(conn, %{"paper" => paper_params}) do
    with {:ok, %Paper{} = paper} <- S2.get_or_fetch_paper(paper_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.paper_path(conn, :show, paper))
      |> render("show.json", paper: paper)
    end
  end

  # Will not cause anything to be fetched
  def show(conn, %{"id" => id}) do
    paper = S2.get_paper!(id)
    render(conn, "show.json", paper: paper)
  end
end
