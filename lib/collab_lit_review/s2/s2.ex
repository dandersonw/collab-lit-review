defmodule CollabLitReview.S2 do
  @moduledoc """
  The S2 context.
  """

  import Ecto.Query, warn: false
  alias CollabLitReview.Repo

  alias CollabLitReview.S2.Author
  alias CollabLitReview.S2.Paper
  alias CollabLitReview.S2.AuthorPaper

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

  def get_author_by_s2_id(s2_id), do: Repo.get_by(Author, s2_id: s2_id)

  def get_or_fetch_author(s2_id) do
    case get_author_by_s2_id(s2_id) do
      nil -> fetch_author_by_s2_id(s2_id)
      author -> author
    end
  end

  defp fetch_author_by_s2_id(s2_id) do
    case HTTPoison.get("https://api.semanticscholar.org/v1/author/" <> Integer.to_string(s2_id)) do
      {:ok, %{body: body}} ->
        case Jason.decode(body) do
          {:ok, %{"authorId" => s2_id, "name" => name, "papers" => papers}} ->
            insert_author_w_paper_stubs(s2_id, name, papers)
          {:error, reason} ->
            IO.inspect reason
            {:error, "Error parsing JSON returned from S2"}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        {:error, "Error connecting to S2"}
    end
  end

  defp insert_author_w_paper_stubs(s2_id, name, papers) do
    author_attrs = %{"s2_id" => s2_id, "name" => name}
    response = create_author(author_attrs)
    case response do
      {:ok, author} ->
        for paper <- papers do
          insert_paper_stub(author, paper)
        end
        author
      _else -> response
    end
  end

  # called with the paper objects returned from the S2 author API
  defp insert_paper_stub(author, stub) do
    case get_paper_by_s2_id(Map.get(stub, "paperId")) do
      nil -> # Only insert if the paper is not already in the DB
        paper = stub
        |> Map.put("is_stub", true)
        |> Map.put("s2_id", Map.get(stub, "paperId"))
        |> create_paper()

        case paper do
          {:ok, paper} -> associate_author_w_paper(author, paper)
          _else -> paper
        end
      paper -> paper
    end
  end

  defp associate_author_w_paper(author, paper) do
    %AuthorPaper{}
    |> AuthorPaper.changeset(%{"author_id" => author.s2_id, "paper_id" => paper.s2_id})
    |> Repo.insert()
  end
  
  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp create_author(attrs \\ %{}) do
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
  defp update_author(%Author{} = author, attrs) do
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
  defp delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  defp change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

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

  def get_paper_by_s2_id(id), do: Repo.get_by(Paper, s2_id: id)

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
