defmodule Template.Auth do
  @moduledoc """
  This module acts as a facade for the `Template.Auth.Behaviour` behaviour.

  See the behaviour module for documentation.
  """

  use Boundary, deps: [Template.Repo], top_level?: true

  use Knigge,
    otp_app: :template,
    behaviour: Template.Auth.Behaviour,
    default: Template.Auth.Implementation
end
