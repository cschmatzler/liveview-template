defmodule Kratos.Client do
  # FIXME: docs
  @moduledoc false

  def new() do
    middleware = [
      {Tesla.Middleware.BaseUrl, Application.get_env(:tesla, Kratos.Client)[:base_url]},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
