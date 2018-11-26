defmodule CollabLitReviewWeb.ReviewEditorChannel do
  use CollabLitReviewWeb, :channel

  alias CollabLitReview.Repo
  alias CollabLitReview.Reviews
  alias CollabLitReview.S2
  alias CollabLitReview.Reviews.Review

  def join("review_editor:" <> review_id, payload, socket) do
    case authorized?(payload, review_id) do
      :unauthorized -> {:error, %{reason: "unauthorized"}}
      {:ok, user_id, review} ->
        socket = socket
        |> assign(:review_id, review_id)
        |> assign(:user, user)
        {:ok, %{"review" => Review.client_view(review)}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (review_editor:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  def handle_in("add_collaborator_to_review", %{"user_email" => user_email}, socket) do
    review = Reviews.get_review(socket.assigns.review_id)
    user = Users.get_user_by_email(user_email)
    case user do
      nil -> {:reply, {:error, "unknown user"}}
      {review, user} ->
        add_collaborator_to_review(user, review)
        broadcast_updated_state(socket.assigns.review_id, socket)
        {:reply, :ok, socket}
    end
  end

  def handle_in("accept_paper_from_discovery", %{"discovery_id" => discovery_id, "paper_id" => paper_id}) do
    review = Reviews.get_review(socket.assigns.review_id)
    discovery = Reviews.get_discovery!(discovery_id)
    paper = Reviews.get_or_fetch_paper(paper_id)
    Reviews.remove_paper_from_discovery(discovery, paper)
    swimlane = Reviews.get_user_swimlane(review, socket.assigns.user)
    Reviews.add_paper_to_beginning_of_swimlane(swimlane, paper)
  end

  defp broadcast_updated_state(review_id, socket) do
    broadcast socket, "update", %{"review" => Review.client_view(review)}
  end

  # Add authorization logic here as required.
  defp authorized?(%{"token" => token, "user_id" => user_id}, review_id) do
      case Phoenix.Token.verify(CollabLitReviewWeb.Endpoint, "user token", max_age: 86400) do
        {:ok, user_id} ->
          review = Reviews.get_review(review_id)
          case review do
            nil -> :unauthroized
            review ->
              review = Repo.preload(:collaborators)
              if Enum.member?(Enum.map(review.collaborators), fn c -> c.id), user_id) do
                {:ok, user_id, review}
              else
                :unauthorized
              end
          end
        {:error, reason} -> :unauthorized
      end
  end
end
