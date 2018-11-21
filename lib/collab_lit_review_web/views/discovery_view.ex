defmodule CollabLitReviewWeb.DiscoveryView do
  use CollabLitReviewWeb, :view
  alias CollabLitReviewWeb.DiscoveryView

  def render("index.json", %{discoveries: discoveries}) do
    %{data: render_many(discoveries, DiscoveryView, "discovery.json")}
  end

  def render("show.json", %{discovery: discovery}) do
    %{data: render_one(discovery, DiscoveryView, "discovery.json")}
  end

  def render("discovery.json", %{discovery: discovery}) do
    %{id: discovery.id,
      type: discovery.type}
  end
end
