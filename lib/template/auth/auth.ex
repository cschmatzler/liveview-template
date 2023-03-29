defmodule Template.Auth do
  @moduledoc """
  The `Auth` module provides business logic and persistence for user authentication.
  """

  use Boundary, deps: [Template.Repo], top_level?: true

  use Knigge,
    otp_app: :template,
    behaviour: Template.Auth.Behaviour,
    default: Template.Auth.Implementation
end
