defmodule CollabLitReview.Reviews.Discovery do
  use Ecto.Schema
  import Ecto.Changeset

  alias CollabLitReview.Reviews.Review
  alias CollabLitReview.S2.Paper
  alias CollabLitReview.S2.Author


  schema "discoveries" do
    # ∈ {"author", "paper"}
    field :type, :string

    belongs_to :review, Review
    many_to_many :papers, Paper, [join_through: "discoveries_papers", join_keys: [discovery_id: :id, paper_id: :s2_id]]

    # one of the two below will be null
    belongs_to :author, Author, references: :s2_id
    belongs_to :paper, Paper, references: :s2_id, type: :string

    timestamps()
  end

  @doc false
  def changeset(discovery, attrs) do
    discovery
    |> cast(attrs, [:type, :review_id, :author_id, :paper_id])
    |> validate_required([:type, :review_id])
  end
end
