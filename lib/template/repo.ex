defmodule Template.Repo do
  @moduledoc false

  use Boundary, top_level?: true

  use Ecto.Repo,
    otp_app: :template,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
