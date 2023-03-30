defmodule Template.Auth do
  @moduledoc """
  This module acts as a facade for the `Template.Auth.Behaviour` behaviour.

  See the behaviour module for documentation.
  """

  use Knigge,
    otp_app: :template,
    behaviour: Template.Auth.Behaviour,
    default: Template.Auth.Implementation,
    delegate_at_runtime?: true
end
