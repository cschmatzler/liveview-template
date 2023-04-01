defmodule External.Sentry.FinchClient do
  @moduledoc """
  An alternative HTTP client for Sentry that uses Finch instead of Hackney.
  """

  @behaviour Sentry.HTTPClient

  @impl Sentry.HTTPClient
  def child_spec() do
    {Finch, name: __MODULE__}
  end

  @impl Sentry.HTTPClient
  def post(url, headers, body) do
    response =
      Finch.build(:post, url, headers, body)
      |> Finch.request(__MODULE__)

    case response do
      {:ok, %Finch.Response{status: status, headers: headers, body: body}} ->
        {:ok, status, headers, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
