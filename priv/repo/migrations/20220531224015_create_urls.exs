defmodule Linex.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :clicks, :integer, defaults: 0
      add :url, :string, null: false
      add :code, :string, null: false

      timestamps()
    end
  end
end
