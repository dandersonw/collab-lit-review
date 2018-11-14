defmodule CollabLitReviewWeb.PaperController do
  use CollabLitReviewWeb, :controller

  alias CollabLitReview.S2
  alias CollabLitReview.S2.Paper

  action_fallback CollabLitReviewWeb.FallbackController

  def index(conn, _params) do
    papers = S2.list_papers()
    render(conn, "index.json", papers: papers)
  end

  def create(conn, %{"paper" => paper_params}) do
    with {:ok, %Paper{} = paper} <- S2.create_paper(paper_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.paper_path(conn, :show, paper))
      |> render("show.json", paper: paper)
    end
  end

  def show(conn, %{"id" => id}) do
    paper = S2.get_paper!(id)
    render(conn, "show.json", paper: paper)
  end

  def update(conn, %{"id" => id, "paper" => paper_params}) do
    paper = S2.get_paper!(id)

    with {:ok, %Paper{} = paper} <- S2.update_paper(paper, paper_params) do
      render(conn, "show.json", paper: paper)
    end
  end

  def delete(conn, %{"id" => id}) do
    paper = S2.get_paper!(id)

    with {:ok, %Paper{}} <- S2.delete_paper(paper) do
      send_resp(conn, :no_content, "")
    end
  end
end
