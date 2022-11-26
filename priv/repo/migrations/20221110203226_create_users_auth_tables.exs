defmodule Leuchtturm.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "create extension if not exists citext", ""

    execute "create schema if not exists authentication", ""

    create table(:users, prefix: "authentication", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :citext, null: false
      add :hashed_password, :string, null: false
      add :name, :string, null: false
      add :confirmed_at, :utc_datetime
      timestamps()
    end

    create unique_index(:users, [:email], prefix: "authentication")

    create table(:tokens, prefix: "authentication", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :token, :binary, null: false
      add :purpose, :string, null: false
      add :sent_to, :string
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end

    create index(:tokens, [:user_id], prefix: "authentication")
    create unique_index(:tokens, [:purpose, :token], prefix: "authentication")
  end
end
