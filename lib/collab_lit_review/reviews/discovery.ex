defmodule CollabLitReview.Reviews.Discovery do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.Reviews.Review
  alias CollabLitReview.S2.Paper


  schema "discoveries" do
    field :type, :string

    belongs_to :review, Review
    many_to_many :papers, Paper, join_through: "discoveries_papers"

    timestamps()
  end

  @doc false
  def changeset(discovery, attrs) do
    discovery
    |> cast(attrs, [:type, :review_id])
    |> validate_required([:type, :review_id])
  end
end
