defmodule Kratos.Client do
  # FIXME: docs
  @moduledoc false

  @base_url Application.compile_env(:tesla, [Kratos.Client, :base_url])

  def new() do
    middleware = [
      {Tesla.Middleware.BaseUrl, @base_url},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end
end
