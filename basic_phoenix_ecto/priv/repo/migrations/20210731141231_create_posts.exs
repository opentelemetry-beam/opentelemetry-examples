defmodule Demo.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :name, :string
      add :body, :text

      timestamps()
    end

  end
end
