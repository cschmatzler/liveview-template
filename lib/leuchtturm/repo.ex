defmodule Leuchtturm.Repo do
  @moduledoc false

  use Boundary, deps: [], exports: [], top_level?: true

  use Ecto.Repo,
    otp_app: :leuchtturm,
    adapter: Ecto.Adapters.Postgres
end
