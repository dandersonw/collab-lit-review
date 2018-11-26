defmodule CollabLitReview.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add :title, :string

      timestamps()
    end

    create table(:reviews_collaborators, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :review_id, references(:reviews, on_delete: :delete_all)
    end

    create index(:reviews_collaborators, [:user_id, :review_id], unique: true, name: :review_collaborators_index)
  end
end
