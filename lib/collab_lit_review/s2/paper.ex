defmodule CollabLitReview.S2.Paper do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Author

  schema "papers" do
    field :abstract, :string
    field :s2_id, :integer
    field :title, :string

    belongs_to :author, Author

    timestamps()
  end

  @doc false
  def changeset(paper, attrs) do
    paper
    |> cast(attrs, [:s2_id, :title, :abstract])
    |> validate_required([:s2_id, :title, :abstract])
  end
end
