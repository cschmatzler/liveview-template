defmodule Template.Repo.Migrations.AddUsers do
  use Ecto.Migration

  # excellent_migrations:safety-assured-for-this-file raw_sql_executed
  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    execute "create extension if not exists citext", ""
    execute "create schema if not exists auth", ""

    role_create_query = "CREATE TYPE users_role AS ENUM ('user', 'admin')"
    role_drop_query = "DROP TYPE users_role"
    execute(role_create_query, role_drop_query)

    create table(:users, prefix: "auth") do
      add :provider, :string, null: false
      add :uid, :string, null: false
      add :email, :string, null: false
      add :name, :string, null: false
      add :image_url, :string
      add :role, :users_role
      timestamps()
    end

    create unique_index(:users, [:provider, :uid], prefix: "auth", concurrently: true)

    create table(:tokens, prefix: "auth") do
      add :token, :binary, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps(updated_at: false)
    end

    create index(:tokens, [:token], prefix: "auth", concurrently: true)
  end
end
