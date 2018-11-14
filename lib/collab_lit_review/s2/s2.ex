defmodule CollabLitReview.S2 do
  @moduledoc """
  The S2 context.
  """

  import Ecto.Query, warn: false
  alias CollabLitReview.Repo

  alias CollabLitReview.S2.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  alias CollabLitReview.S2.Paper

  @doc """
  Returns the list of papers.

  ## Examples

      iex> list_papers()
      [%Paper{}, ...]

  """
  def list_papers do
    Repo.all(Paper)
  end

  @doc """
  Gets a single paper.

  Raises `Ecto.NoResultsError` if the Paper does not exist.

  ## Examples

      iex> get_paper!(123)
      %Paper{}

      iex> get_paper!(456)
      ** (Ecto.NoResultsError)

  """
  def get_paper!(id), do: Repo.get!(Paper, id)

  @doc """
  Creates a paper.

  ## Examples

      iex> create_paper(%{field: value})
      {:ok, %Paper{}}

      iex> create_paper(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_paper(attrs \\ %{}) do
    %Paper{}
    |> Paper.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a paper.

  ## Examples

      iex> update_paper(paper, %{field: new_value})
      {:ok, %Paper{}}

      iex> update_paper(paper, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_paper(%Paper{} = paper, attrs) do
    paper
    |> Paper.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Paper.

  ## Examples

      iex> delete_paper(paper)
      {:ok, %Paper{}}

      iex> delete_paper(paper)
      {:error, %Ecto.Changeset{}}

  """
  def delete_paper(%Paper{} = paper) do
    Repo.delete(paper)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking paper changes.

  ## Examples

      iex> change_paper(paper)
      %Ecto.Changeset{source: %Paper{}}

  """
  def change_paper(%Paper{} = paper) do
    Paper.changeset(paper, %{})
  end
end
