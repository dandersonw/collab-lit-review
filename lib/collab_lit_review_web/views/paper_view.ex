defmodule CollabLitReviewWeb.PaperView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.PaperView

  def render("index.json", %{papers: papers}) do
    %{data: render_many(papers, PaperView, "paper.json")}
  end

  def render("show.json", %{paper: paper}) do
    %{data: render_one(paper, PaperView, "paper.json")}
  end

  def render("paper.json", %{paper: paper}) do
    %{id: paper.id,
      s2_id: paper.s2_id,
      title: paper.title,
      abstract: paper.abstract}
  end
end
