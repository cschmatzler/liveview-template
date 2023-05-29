defmodule Kratos.Models.Session do
  @moduledoc false

  @derive {Nestru.Decoder,
           hint: %{
             authentication_methods: [Kratos.Models.SessionAuthenticationMethod],
             devices: [Kratos.Models.SessionDevice],
             identity: Kratos.Models.Identity
           }}
  defstruct [
    :active,
    :authenticated_at,
    :authentication_methods,
    :authenticator_assurance_level,
    :devices,
    :expires_at,
    :id,
    :identity,
    :issued_at
  ]

  @type t :: %__MODULE__{
          :active => boolean() | nil,
          :authenticated_at => DateTime.t() | nil,
          :authentication_methods => [Kratos.Models.SessionAuthenticationMethod.t()] | nil,
          :authenticator_assurance_level => String.t(),
          :devices => [Kratos.Models.SessionDevice.t()] | nil,
          :expires_at => DateTime.t() | nil,
          :id => String.t(),
          :identity => Kratos.Models.Identity.t(),
          :issued_at => DateTime.t() | nil
        }
end
