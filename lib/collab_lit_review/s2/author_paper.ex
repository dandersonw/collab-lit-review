defmodule CollabLitReview.S2.AuthorPaper do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Author
  alias CollabLitReview.S2.Paper

  @primary_key false
  schema "authors_papers" do
    belongs_to :author, Author, [references: :s2_id]
    belongs_to :paper, Paper, [references: :s2_id, type: :string]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:author_id, :paper_id])
    |> validate_required([:author_id, :paper_id])
  end
end
