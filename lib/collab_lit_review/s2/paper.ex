defmodule CollabLitReview.S2.Paper do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Author
  alias CollabLitReview.S2.AuthorPaper
  alias CollabLitReview.S2.Paper


  @primary_key {:s2_id, :string, autogenerate: false}
  schema "papers" do
    field :abstract, :string
    field :title, :string
    field :year, :integer

    field :paperId, :string, virtual: true

    # If we've only seen this paper in an author result
    field :is_stub, :boolean, default: false

    many_to_many :authors, Author, [join_through: AuthorPaper, join_keys: [paper_id: :s2_id, author_id: :s2_id]]
    many_to_many :references, Paper, [join_through: Citation, join_keys: [citer_id: :s2_id, citee_id: :s2_id]]
    many_to_many :citations, Paper, [join_through: Citation, join_keys: [citee_id: :s2_id, citer_id: :s2_id]]

    timestamps()
  end

  @doc false
  def changeset(paper, attrs) do
    paper
    |> cast(attrs, [:s2_id, :title, :abstract, :is_stub, :paperId])
    |> convert_id()
    |> validate_required([:s2_id, :title, :is_stub])
    # |> validate_stub_requirements()
    |> unique_constraint(:s2_id)
  end

  # def validate_stub_requirements(paper) do
  # end

  def convert_id(%Ecto.Changeset{valid?: true, changes: %{paperId: paper_id}} = changeset) do
    change(changeset, %{s2_id: paper_id})
  end
  def convert_id(changeset), do: changeset

end
