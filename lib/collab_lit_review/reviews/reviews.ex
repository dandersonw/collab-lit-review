defmodule CollabLitReview.Reviews do
  @moduledoc """
  The Reviews context.
  """

  import Ecto.Query, warn: false
  alias CollabLitReview.Repo

  alias CollabLitReview.Reviews.Review
  alias CollabLitReview.S2

  @doc """
  Returns a user's reviews

  ## Examples

      iex> list_reviews()
      [%Review{}, ...]

  """
  def list_reviews(user) do
    Repo.all(from r in Review,
      join: c in assoc(r, :collaborators),
      where: ^user.id == c.id)
  end

  @doc """
  Gets a single review.

  Raises `Ecto.NoResultsError` if the Review does not exist.

  ## Examples

      iex> get_review!(123)
      %Review{}

      iex> get_review!(456)
      ** (Ecto.NoResultsError)

  """
  def get_review!(id), do: Repo.get!(Review, id)

  def add_collaborator_to_review(user, review) do
    existing_collaborators = Repo.all(Ecto.assoc(review, :collaborators))
    review
    |> Repo.preload(:collaborators)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:collaborators, [user | existing_collaborators])
    |> Repo.update!()
  end

  @doc """
  Creates a review.

  ## Examples

      iex> create_review(%{field: value})
      {:ok, %Review{}}

      iex> create_review(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp db_create_review(attrs \\ %{}) do
    %Review{}
    |> Review.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a review.

  ## Examples

      iex> update_review(review, %{field: new_value})
      {:ok, %Review{}}

      iex> update_review(review, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp update_review(%Review{} = review, attrs) do
    review
    |> Review.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Review.

  ## Examples

      iex> delete_review(review)
      {:ok, %Review{}}

      iex> delete_review(review)
      {:error, %Ecto.Changeset{}}

  """
  def delete_review(%Review{} = review) do
    Repo.delete(review)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking review changes.

  ## Examples

      iex> change_review(review)
      %Ecto.Changeset{source: %Review{}}

  """
  defp change_review(%Review{} = review) do
    Review.changeset(review, %{})
  end

  alias CollabLitReview.Reviews.Swimlane

  @doc """
  Returns the list of swimlanes.

  ## Examples

      iex> list_swimlanes()
      [%Swimlane{}, ...]

  """
  def list_swimlanes(review) do
    Repo.all(from s in Swimlane, where: s.review_id == ^review.id)
  end

  @doc """
  Gets a single swimlane.

  Raises `Ecto.NoResultsError` if the Swimlane does not exist.

  ## Examples

      iex> get_swimlane!(123)
      %Swimlane{}

      iex> get_swimlane!(456)
      ** (Ecto.NoResultsError)

  """
  def get_swimlane!(id), do: Repo.get!(Swimlane, id)

  @doc """
  Creates a swimlane.

  ## Examples

      iex> create_swimlane(%{field: value})
      {:ok, %Swimlane{}}

      iex> create_swimlane(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp create_swimlane(attrs \\ %{}) do
    %Swimlane{}
    |> Swimlane.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a swimlane.

  ## Examples

      iex> update_swimlane(swimlane, %{field: new_value})
      {:ok, %Swimlane{}}

      iex> update_swimlane(swimlane, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp update_swimlane(%Swimlane{} = swimlane, attrs) do
    swimlane
    |> Swimlane.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Swimlane.

  ## Examples

      iex> delete_swimlane(swimlane)
      {:ok, %Swimlane{}}

      iex> delete_swimlane(swimlane)
      {:error, %Ecto.Changeset{}}

  """
  def delete_swimlane(%Swimlane{} = swimlane) do
    Repo.delete(swimlane)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking swimlane changes.

  ## Examples

      iex> change_swimlane(swimlane)
      %Ecto.Changeset{source: %Swimlane{}}

  """
  defp change_swimlane(%Swimlane{} = swimlane) do
    Swimlane.changeset(swimlane, %{})
  end

  alias CollabLitReview.Reviews.Bucket

  @doc """
  Returns the list of buckets.

  ## Examples

      iex> list_buckets()
      [%Bucket{}, ...]

  """
  def list_buckets(swimlane) do
    Repo.all(from b in Bucket, where: b.swimlane_id == ^swimlane.id)
  end

  @doc """
  Gets a single bucket.

  Raises `Ecto.NoResultsError` if the Bucket does not exist.

  ## Examples

      iex> get_bucket!(123)
      %Bucket{}

      iex> get_bucket!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bucket!(id), do: Repo.get!(Bucket, id)

  @doc """
  Creates a bucket.

  ## Examples

      iex> create_bucket(%{field: value})
      {:ok, %Bucket{}}

      iex> create_bucket(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp create_bucket(attrs \\ %{}) do
    %Bucket{}
    |> Bucket.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bucket.

  ## Examples

      iex> update_bucket(bucket, %{field: new_value})
      {:ok, %Bucket{}}

      iex> update_bucket(bucket, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp update_bucket(%Bucket{} = bucket, attrs) do
    bucket
    |> Bucket.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Bucket.

  ## Examples

      iex> delete_bucket(bucket)
      {:ok, %Bucket{}}

      iex> delete_bucket(bucket)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bucket(%Bucket{} = bucket) do
    Repo.delete(bucket)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bucket changes.

  ## Examples

      iex> change_bucket(bucket)
      %Ecto.Changeset{source: %Bucket{}}

  """
  defp change_bucket(%Bucket{} = bucket) do
    Bucket.changeset(bucket, %{})
  end

  alias CollabLitReview.Reviews.Discovery

  @doc """
  Returns the list of discoveries.

  ## Examples

      iex> list_discoveries()
      [%Discovery{}, ...]

  """
  def list_discoveries(review) do
    Repo.all(from d in Discovery, where: d.review_id == ^review.id)
  end

  @doc """
  Gets a single discovery.

  Raises `Ecto.NoResultsError` if the Discovery does not exist.

  ## Examples

      iex> get_discovery!(123)
      %Discovery{}

      iex> get_discovery!(456)
      ** (Ecto.NoResultsError)

  """
  def get_discovery!(id), do: Repo.get!(Discovery, id)

  @doc """
  Creates a discovery, from either an author or a paper.

  ## Examples

  iex> create_discovery(review, author: author)
  %Discovery{type: "author", ...}

  iex> create_discovery(review, paper: paper)
  %Discovery{type: "paper", ...}
  """
  def create_discovery(review, opts \\ []) do
    attrs = %{:review_id => review.id}
    {attrs, papers} = case Keyword.get(opts, :author) do
                        nil ->
                          case Keyword.get(opts, :paper) do
                            nil -> raise ArgumentError
                            paper ->
                              attrs = attrs
                              |> Map.put(:type, "paper")
                              |> Map.put(:paper_id, paper.s2_id)
                              paper = S2.get_or_fetch_paper(paper.s2_id)
                              |> Repo.preload(:references)
                              papers = paper.references
                              {attrs, papers}
                          end
                        author ->
                          attrs = attrs
                          |> Map.put(:type, "author")
                          |> Map.put(:author_id, author.s2_id)
                          author = S2.get_or_fetch_author(author.s2_id)
                          |> Repo.preload(:papers)
                          papers = author.papers
                          {attrs, papers}
                      end
    case discovery = db_create_discovery(attrs) do
      {:error, _} -> discovery
      {:ok, discovery} ->
        discovery
        |> Repo.preload(:papers)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:papers, papers)
        |> Repo.update()
    end    
  end

  def remove_paper_from_discovery(discovery, paper) do
    existing_papers = Rep.all(Ecto.assoc(discovery, :papers))
    discovery
    |> Repo.preload(:papers)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:papers, List.delete(existing_papers, paper))
    |> Repo.update!()
  end

  @doc """
  Creates a discovery.

  ## Examples

      iex> create_discovery(%{field: value})
      {:ok, %Discovery{}}

      iex> create_discovery(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp db_create_discovery(attrs \\ %{}) do
    %Discovery{}
    |> Discovery.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a discovery.

  ## Examples

      iex> update_discovery(discovery, %{field: new_value})
      {:ok, %Discovery{}}

      iex> update_discovery(discovery, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp update_discovery(%Discovery{} = discovery, attrs) do
    discovery
    |> Discovery.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Discovery.

  ## Examples

      iex> delete_discovery(discovery)
      {:ok, %Discovery{}}

      iex> delete_discovery(discovery)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discovery(%Discovery{} = discovery) do
    Repo.delete(discovery)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discovery changes.

  ## Examples

      iex> change_discovery(discovery)
      %Ecto.Changeset{source: %Discovery{}}

  """
  defp change_discovery(%Discovery{} = discovery) do
    Discovery.changeset(discovery, %{})
  end
end
