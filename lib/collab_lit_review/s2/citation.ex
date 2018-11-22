defmodule CollabLitReview.S2.Citation do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Paper

  @primary_key false
  schema "citations" do
    belongs_to :citation, Paper, [references: :s2_id, type: :string, foreign_key: :citer]
    belongs_to :reference, Paper, [references: :s2_id, type: :string, foreign_key: :citee]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:citer, :citee])
    |> validate_required([:citer, :citee])
    |> unique_constraint(:citer, name: :citations_index)
  end
end
