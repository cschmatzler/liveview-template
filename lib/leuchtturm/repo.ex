defmodule Leuchtturm.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :leuchtturm,
    adapter: Ecto.Adapters.Postgres

  use EctoDbg
end
