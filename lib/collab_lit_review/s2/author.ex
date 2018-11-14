defmodule CollabLitReview.S2.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Paper

  schema "authors" do
    field :name, :string
    field :s2_id, :integer

    has_many :papers, Paper

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:s2_id, :name])
    |> validate_required([:s2_id, :name])
  end
end
