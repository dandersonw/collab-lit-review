defmodule CollabLitReview.S2.Citation do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.S2.Paper

  @primary_key false
  schema "citations" do
    belongs_to :citer, Paper, [references: :s2_id, type: :string]
    belongs_to :citee, Paper, [references: :s2_id, type: :string]

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:citer_id, :citee_id])
    |> validate_required([:citer_id, :citee_id])
    |> unique_constraint(:citer_id, name: :citations_index)
  end
end
