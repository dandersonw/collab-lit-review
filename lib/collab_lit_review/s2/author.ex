defmodule CollabLitReview.S2.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Paper
  alias CollabLitReview.S2.AuthorPaper

  @primary_key {:s2_id, :integer, autogenerate: false}
  schema "authors" do
    field :name, :string

    # If we've only seen this author in a paper result
    field :is_stub, :boolean, default: false

    many_to_many :papers, Paper, [join_through: AuthorPaper, join_keys: [author_id: :s2_id, paper_id: :s2_id]]

    field :authorId, :integer, virtual: true

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:s2_id, :name, :is_stub, :authorId])
    |> convert_id()
    |> validate_required([:s2_id, :name])
    |> unique_constraint(:s2_id)
  end

  def convert_id(%Ecto.Changeset{valid?: true, changes: %{authorId: author_id}} = changeset) do
    change(changeset, s2_id: author_id)
  end
  def convert_id(changeset), do: changeset

end
