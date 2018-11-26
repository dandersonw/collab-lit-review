defmodule CollabLitReview.Reviews.Review do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.Reviews.Swimlane
  alias CollabLitReview.Users.User

  schema "reviews" do
    field :title, :string

    many_to_many :collaborators, User, join_through: "reviews_collaborators"
    has_many :swimlanes, Swimlane

    timestamps()
  end

  @doc false
  def changeset(review, attrs) do
    review
    |> cast(attrs, [:title])
    |> cast_assoc(:collaborators)
    #|> foreign_key_constraint(:collaborators)
    |> validate_required([:title])
  end

  def client_view(review) do
    %{}
  end
end
