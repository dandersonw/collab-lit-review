defmodule CollabLitReviewWeb.SwimlaneView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.SwimlaneView

  def render("index.json", %{swimlanes: swimlanes}) do
    %{data: render_many(swimlanes, SwimlaneView, "swimlane.json")}
  end

  def render("show.json", %{swimlane: swimlane}) do
    %{data: render_one(swimlane, SwimlaneView, "swimlane.json")}
  end

  def render("swimlane.json", %{swimlane: swimlane}) do
    %{id: swimlane.id,
      name: swimlane.name}
  end
end
