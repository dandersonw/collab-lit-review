defmodule CollabLitReview.Repo.Migrations.CreateSwimlanes do
  use Ecto.Migration

  def change do
    create table(:swimlanes) do
      add :name, :string
      add :review_id, references(:reviews, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all), null: true

      timestamps()
    end

    create index(:swimlanes, [:review_id])

  end
end
