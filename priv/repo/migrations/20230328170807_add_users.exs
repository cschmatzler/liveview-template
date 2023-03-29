defmodule Template.Repo.Migrations.AddUsers do
  use Ecto.Migration

  def change do
    execute "create extension if not exists citext", ""
    execute "create schema if not exists auth", ""

    create table(:users, prefix: "auth") do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :image_url, :string
      timestamps()
    end

    create unique_index(:users, [:provider, :uid], prefix: "auth")

    create table(:tokens, prefix: "auth") do
      add :token, :binary, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end

    create index(:tokens, [:token], prefix: "auth")
  end
end
