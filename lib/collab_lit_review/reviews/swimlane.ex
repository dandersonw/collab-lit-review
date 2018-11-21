defmodule CollabLitReview.Reviews.Swimlane do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.Reviews.Review
  alias CollabLitReview.Reviews.Bucket

  schema "swimlanes" do
    field :name, :string

    belongs_to :review, Review
    has_many :buckets, Bucket

    timestamps()
  end

  @doc false
  def changeset(swimlane, attrs) do
    swimlane
    |> cast(attrs, [:name, :review_id])
    |> validate_required([:name, :review_id])
  end
end
