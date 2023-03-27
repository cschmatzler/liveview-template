defmodule Leuchtturm.Repo do
  @moduledoc false

  use Boundary, top_level?: true

  use Ecto.Repo,
    otp_app: :leuchtturm,
    adapter: Ecto.Adapters.Postgres
end
