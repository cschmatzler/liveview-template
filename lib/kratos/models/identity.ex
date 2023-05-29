defmodule Kratos.Models.Identity do
  @moduledoc false

  @derive Nestru.Decoder
  defstruct [
    :created_at,
    :credentials,
    :id,
    :metadata_admin,
    :metadata_public,
    :recovery_addresses,
    :schema_id,
    :schema_url,
    :state,
    :state_changed_at,
    :traits,
    :updated_at,
    :verifiable_addresses
  ]

  @type t :: %__MODULE__{
          :created_at => DateTime.t() | nil,
          :credentials => %{optional(String.t()) => Kratos.Models.IdentityCredentials.t()} | nil,
          :id => String.t(),
          :metadata_admin => AnyType | nil,
          :metadata_public => AnyType | nil,
          :recovery_addresses => [Kratos.Models.RecoveryIdentityAddress.t()] | nil,
          :schema_id => String.t(),
          :schema_url => String.t(),
          :state => Kratos.Models.IdentityState.t() | nil,
          :state_changed_at => DateTime.t() | nil,
          :traits => AnyType | nil,
          :updated_at => DateTime.t() | nil,
          :verifiable_addresses => [Kratos.Models.VerifiableIdentityAddress.t()] | nil
        }
end
