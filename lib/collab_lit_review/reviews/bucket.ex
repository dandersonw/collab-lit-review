defmodule CollabLitReview.Reviews.Bucket do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.Reviews.Swimlane
  alias CollabLitReview.S2.Paper


  schema "buckets" do
    field :name, :string
    field :position, :integer

    belongs_to :swimlane, Swimlane
    many_to_many :papers, Paper, join_through: "buckets_papers"

    timestamps()
  end

  @doc false
  def changeset(bucket, attrs) do
    bucket
    |> cast(attrs, [:name, :position, :swimlane_id])
    |> validate_required([:name, :position, :swimlane_id])
  end
end
