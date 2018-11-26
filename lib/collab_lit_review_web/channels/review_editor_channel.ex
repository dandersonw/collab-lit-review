defmodule CollabLitReviewWeb.ReviewEditorChannel do
  use CollabLitReviewWeb, :channel

  alias CollabLitReview.Repo
  alias CollabLitReview.Reviews
  alias CollabLitReview.Users
  alias CollabLitReview.S2
  alias CollabLitReview.Reviews.Review

  def join("review_editor:" <> review_id, _payload, socket) do
    user_id = socket.assigns.user_id
    case authorized?(user_id, review_id) do
      :unauthorized -> {:error, %{reason: "unauthorized"}}
      {:ok, review} ->
        socket = socket
        |> assign(:review_id, review_id)
        |> assign(:user, Users.get_user!(user_id))
        #{:ok, %{"review" => generate_client_view(user_id, review_id)}, socket}
        {:ok, %{"review" => Review.client_view(review)}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  #def handle_in("ping", payload, socket) do
  #  {:reply, {:ok, payload}, socket}
  #end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (review_editor:lobby).
  #def handle_in("shout", payload, socket) do
  #  broadcast socket, "shout", payload
  #  {:noreply, socket}
  #end

  def handle_in("add_collaborator_to_review", %{"user_email" => user_email}, socket) do
    review = Reviews.get_review(socket.assigns.review_id)
    user = Users.get_user_by_email(user_email)
    case user do
      nil -> {:reply, {:error, "unknown user"}}
      user ->
        Reviews.add_collaborator_to_review(user, review)
        broadcast_updated_state(socket.assigns.review_id, socket)
        {:reply, :ok, socket}
    end
  end

  def handle_in("accept_paper_from_discovery", %{"discovery_id" => discovery_id, "paper_id" => paper_id}, socket) do
    review = Reviews.get_review(socket.assigns.review_id)
    discovery = Reviews.get_discovery!(discovery_id)
    paper = S2.get_or_fetch_paper(paper_id)
    Reviews.remove_paper_from_discovery(discovery, paper)
    swimlane = Reviews.get_user_swimlane(review, socket.assigns.user)
    Reviews.add_paper_to_beginning_of_swimlane(swimlane, paper)
  end

  defp broadcast_updated_state(review_id, socket) do
    broadcast socket, "update", %{"review" => Review.client_view(Reviews.get_review!(review_id))}
  end

  # Add authorization logic here as required.
  defp authorized?(user_id, review_id) do
    case Reviews.get_review(review_id) do
      nil -> :unauthorized
      review ->
        review = Repo.preload(review, :collaborators)
        if Enum.member?(Enum.map(review.collaborators, fn c -> c.id end), user_id) do
          {:ok, review}
        else
          :unauthorized
        end
    end
  end


  #
  # State
  #
  # title:
  # collaborators:
  # swimlanes:
  # buckets:
  # papers:
  # authors:

  defp flatten(object, key) do
    Map.put(object, key, Enum.uniq(Enum.map(object[key], fn x -> x.id end)))
  end

  defp flatten2(object, key) do
    Map.put(object, key, object[key].id)
  end

  defp uniquify(object_list) do
    Enum.uniq_by(object_list, fn object -> object.id end);
  end

  defp generate_client_view(user_id, review_id) do
    case Reviews.get_review(review_id) do
      nil -> :error
      review ->
        # Start with the review.
        review = review |> Repo.preload([:collaborators, :swimlanes])
        # Get collaborators and swimlanes from the review.
        collaborators = review.collaborators
        swimlanes = review.swimlanes |> Repo.preload(:buckets)
        # Get buckets from the swimlanes
        buckets = List.foldl(swimlanes, [], fn (swimlane, acc) ->
          swimlane.buckets ++ acc
        end) |> uniquify |> Repo.preload([:papers])
        # Get papers from the buckets
        papers = List.foldl(buckets, [], fn (bucket, acc) ->
          bucket.papers ++ acc
        end) |> uniquify |> Repo.preload([:authors, :references, :citations])
        # Get authors, references, and citations from the papers
        {authors, references, citations} = List.foldl(papers, {[], [], []}, fn (paper, acc) ->
          {paper.authors ++ (acc |> elem(0)), paper.references ++ (acc |> elem(1)), paper.citations ++ (acc |> elem(3))}
        end)
        authors = uniquify(authors)
        references = uniquify(references)
        citations = uniquify(citations)
        # Now flatten all those member lists to ids to save space
        review = review |> flatten(:collaborators) |> flatten(:swimlanes)
        swimlanes = swimlanes |> flatten(:buckets)
        buckets = buckets |> flatten(:papers)
        papers = papers |> flatten(:authors) |> flatten(:references) |> flatten(:citations)
        # Construct and return the state
        %{
          "title" => review.title,
          "collaborators" => collaborators,
          "swimlanes" => swimlanes,
          "buckets" => buckets,
          "papers" => papers,
          "authors" => authors,
          "references" => references,
          "citations" => citations,
        }
    end
  end
end
