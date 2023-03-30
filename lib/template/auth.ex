defmodule Template.Auth do
  @moduledoc """
  This module acts as a facade for the `Template.Auth.Behaviour` behaviour.

  See the behaviour module for documentation.
  """

  alias Template.Auth.{Behaviour, Implementation}

  use Knigge,
    otp_app: :template,
    behaviour: Behaviour,
    default: Implementation,
    delegate_at_runtime?: true
end
