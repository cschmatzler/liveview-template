defmodule Kratos.URI do
  @moduledoc false

  @base_url Application.compile_env(:tesla, [Kratos.Client, :base_url])

  @doc """
  """
  def getURIForFlow(flow, query \\ "") do
    "#{String.trim_trailing(@base_url, "/")}/self-service/#{flow}/browser?#{query}"
  end
end
