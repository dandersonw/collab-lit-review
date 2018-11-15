defmodule CollabLitReview.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :s2_id, :integer, primary_key: true
      add :name, :string

      # If all papers have not been fetched
      add :is_stub, :boolean

      timestamps()
    end

    create index(:authors, [:s2_id], unique: true)
  end
end
