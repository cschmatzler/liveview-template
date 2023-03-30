defmodule Template.Auth do
  @moduledoc """
  This module acts as a facade for the `Template.Auth.Behaviour` behaviour.

  See the behaviour module for documentation.
  """

  use Boundary, deps: [Template.Repo], top_level?: true

  use Auth.Macro
end

