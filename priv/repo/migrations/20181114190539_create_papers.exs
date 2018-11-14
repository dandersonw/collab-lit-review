defmodule CollabLitReview.Repo.Migrations.CreatePapers do
  use Ecto.Migration

  def change do
    create table(:papers) do
      add :s2_id, :integer
      add :title, :string
      add :abstract, :text
      add :author_id, references(:authors, on_delete: :nothing)

      timestamps()
    end

    create index(:papers, [:author_id])
    create index(:papers, [:s2_id], unique: true)
  end
end
