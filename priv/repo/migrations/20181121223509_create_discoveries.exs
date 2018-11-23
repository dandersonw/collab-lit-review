defmodule CollabLitReview.Repo.Migrations.CreateDiscoveries do
  use Ecto.Migration

  def change do
    create table(:discoveries) do
      add :type, :string
      add :review_id, references(:reviews, on_delete: :nothing)
      add :author_id, references(:authors, column: :s2_id)
      add :paper_id, references(:papers, column: :s2_id, type: :string)


      timestamps()
    end

    create index(:discoveries, [:review_id])

    create table(:discoveries_papers, primary_key: false) do
      add :discovery_id, references(:discoveries)
      add :paper_id, references(:papers, column: :s2_id, type: :string)
    end

    create index(:discoveries_papers, [:discovery_id, :paper_id], unique: true, name: :discoveries_papers_index)
  end
end
