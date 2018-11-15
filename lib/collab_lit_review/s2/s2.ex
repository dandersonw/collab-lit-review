defmodule CollabLitReview.S2 do
  @moduledoc """
  The S2 context.
  """

  import Ecto.Query, warn: false
  alias CollabLitReview.Repo

  alias CollabLitReview.S2.Author
  alias CollabLitReview.S2.Paper
  alias CollabLitReview.S2.AuthorPaper
  alias CollabLitReview.S2.Citation

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
  def get_author(id), do: Repo.get(Author, id)

  def get_or_fetch_author(s2_id) do
    case get_author(s2_id) do
      nil -> fetch_author(s2_id)
      %Author{is_stub: true} = author -> fetch_author(s2_id, existing: author)
      author -> author
    end
  end

  # TODO: Add in other forms of paper identification (DOI, arXiv ID)
  def get_or_fetch_paper(s2_id) do
    case get_paper(s2_id) do
      nil -> fetch_paper(s2_id)
      %Paper{is_stub: true} = paper -> fetch_paper(s2_id, existing: paper)
      paper -> paper
    end
  end

  defp get_and_decode_from_s2(url, callback) do
    case HTTPoison.get(url) do
      {:ok, %{body: body}} ->
        case Jason.decode(body) do
          {:ok, data} -> callback.(data)
          {:error, reason} ->
            IO.inspect reason
            {:error, "Error parsing JSON returned from S2"}
        end
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error connecting to S2"}
    end
  end
  
  defp fetch_author(s2_id, opts \\ []) do
    url = "https://api.semanticscholar.org/v1/author/" <> Integer.to_string(s2_id)
    get_and_decode_from_s2(url,
      fn author_data ->
        papers = Map.get(author_data, "papers")
        insert_author_w_paper_stubs(author_data, papers, Keyword.get(opts, :existing))
    end)
  end

  defp fetch_paper(s2_id, opts \\ []) do
    # IO.inspect(Keyword.get(opts, :existing))
    url = "https://api.semanticscholar.org/v1/paper/" <> s2_id
    get_and_decode_from_s2(url,
      fn paper_data ->
        insert_paper_w_author_stubs(paper_data, Keyword.get(opts, :existing))
    end)
  end

  defp insert_author_w_paper_stubs(author_attrs, papers, existing) do
    response = case existing do
                 nil -> create_author(author_attrs)
                 existing -> update_author(existing, Map.put(author_attrs, "is_stub", false))
               end
    case response do
      {:ok, author} ->
        for paper_attrs <- papers do
          paper = insert_stub(Paper, paper_attrs)
          associate_author_w_paper(author, paper)
        end
        author
      _else -> response
    end
  end

  defp insert_paper_w_author_stubs(paper_attrs, existing) do
    response = case existing do
                 nil -> create_paper(paper_attrs)
                 existing -> update_paper(existing, Map.put(paper_attrs, "is_stub", false))
               end
    case response do
      {:ok, paper} ->
        insert_author_stubs(paper, Map.get(paper_attrs, "authors"))
        for citer_attrs <- Map.get(paper_attrs, "citations") do
          citer = insert_stub(Paper, citer_attrs)
          insert_author_stubs(citer, Map.get(citer_attrs, "authors"))
          create_citation(citer: citer, citee: paper)
        end
        for citee_attrs <- Map.get(paper_attrs, "references") do
          citee = insert_stub(Paper, citee_attrs)
          insert_author_stubs(citee, Map.get(citee_attrs, "authors"))
          create_citation(citer: paper, citee: citee)
        end
        paper
      _else -> response
    end
  end
  
  defp insert_author_stubs(paper, authors) do
    for author_attrs <- authors do
      if Map.get(author_attrs, "authorId") do
        author = insert_stub(Author, author_attrs)
        associate_author_w_paper(author, paper)
      end
    end    
  end

  defp insert_stub(type, attrs) do
    stub = struct(type, %{})
    |> type.changeset(attrs)

    case Repo.get_by(type, s2_id: stub.changes.s2_id) do
      nil ->
        stub = stub
        |> Ecto.Changeset.change(is_stub: true)
        |> Repo.insert()

        case stub do
          {:ok, inserted} -> inserted
          err -> err
        end
      something -> something
    end
  end

  # called with the paper objects returned from the S2 author API
  # defp insert_paper_stub(author, stub) do
  #   case get_paper(Map.get(stub, "paperId")) do
  #     nil -> # Only insert if the paper is not already in the DB
  #       paper = stub
  #       |> Map.put("is_stub", true)
  #       |> Map.put("s2_id", Map.get(stub, "paperId"))
  #       |> create_paper()

  #       case paper do
  #         {:ok, paper} -> associate_author_w_paper(author, paper)
  #         _else -> paper
  #       end
  #     paper -> paper
  #   end
  # end

  defp associate_author_w_paper(author, paper) do
    %AuthorPaper{}
    |> AuthorPaper.changeset(%{"author_id" => author.s2_id, "paper_id" => paper.s2_id})
    |> Repo.insert()
  end

  defp create_citation(citer: citer, citee: citee) do
    %Citation{}
    |> Citation.changeset(%{"citer" => citer.s2_id, "citee" => citee.s2_id})
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
  def get_paper(id), do: Repo.get(Paper, id)

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
