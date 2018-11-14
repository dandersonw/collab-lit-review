defmodule CollabLitReview.S2.Paper do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Author
  alias CollabLitReview.S2.AuthorPaper

  schema "papers" do
    field :abstract, :string
    field :s2_id, :string
    field :title, :string
    field :year, :integer
    field :is_stub, :boolean

    many_to_many :authors, Author, [join_through: AuthorPaper, join_keys: [paper_id: :s2_id, author_id: :s2_id]]

    timestamps()
  end

  @doc false
  def changeset(paper, attrs) do
    paper
    |> cast(attrs, [:s2_id, :title, :abstract, :is_stub])
    |> validate_required([:s2_id, :title, :is_stub])
    |> unique_constraint(:s2_id)
  end
end
