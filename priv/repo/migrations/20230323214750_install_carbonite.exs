defmodule Leuchtturm.Repo.Migrations.InstallCarbonite do
  use Ecto.Migration

  def up do
    Carbonite.Migrations.up(1, carbonite_prefix: "audit")
    Carbonite.Migrations.up(2, carbonite_prefix: "audit")
    Carbonite.Migrations.up(3, carbonite_prefix: "audit")
    Carbonite.Migrations.up(4, carbonite_prefix: "audit")
    Carbonite.Migrations.up(5, carbonite_prefix: "audit")
  end

  def down do
    Carbonite.Migrations.down(5, carbonite_prefix: "audit")
    Carbonite.Migrations.down(4, carbonite_prefix: "audit")
    Carbonite.Migrations.down(3, carbonite_prefix: "audit")
    Carbonite.Migrations.down(2, carbonite_prefix: "audit")
    Carbonite.Migrations.down(1, carbonite_prefix: "audit")
  end
end
