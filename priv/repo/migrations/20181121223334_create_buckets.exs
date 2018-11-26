defmodule CollabLitReview.Repo.Migrations.CreateBuckets do
  use Ecto.Migration

  def change do
    create table(:buckets) do
      add :name, :string
      add :position, :integer
      add :swimlane_id, references(:swimlanes, on_delete: :delete_all)

      timestamps()
    end

    create index(:buckets, [:swimlane_id])

    create table(:buckets_papers, primary_key: false) do
      add :bucket_id, references(:buckets, on_delete: :delete_all)
      add :paper_id, references(:papers, column: :s2_id, type: :string, on_delete: :delete_all)
    end

    create index(:buckets_papers, [:bucket_id, :paper_id], unique: true)
  end
end
