defmodule CollabLitReview.S2.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Paper
  alias CollabLitReview.S2.AuthorPaper

  schema "authors" do
    field :name, :string
    field :s2_id, :integer

    many_to_many :papers, Paper, [join_through: AuthorPaper, join_keys: [author_id: :s2_id, paper_id: :s2_id]]

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:s2_id, :name])
    |> validate_required([:s2_id, :name])
    |> unique_constraint(:s2_id)
  end

  # def populate

end
