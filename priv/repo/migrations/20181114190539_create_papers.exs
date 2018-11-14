defmodule CollabLitReview.Repo.Migrations.CreatePapers do
  use Ecto.Migration

  def change do
    create table(:papers) do
      add :s2_id, :string
      add :title, :string
      add :abstract, :text, nullable: true
      add :year, :integer
      add :is_stub, :boolean

      timestamps()
    end

    create index(:papers, [:s2_id], unique: true)

    create table(:authors_papers) do
      add :paper_id, references(:papers, column: :s2_id, type: :string)
      add :author_id, references(:authors, column: :s2_id)
      timestamps()
    end
  end
end
