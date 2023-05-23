defmodule Kratos.Models.RegistrationFlow do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{ui: Kratos.Models.UIContainer}}
  defstruct [
    # :active,
    :expires_at,
    :id,
    :issued_at,
    # :oauth2_login_challenge,
    # :oauth2_login_request,
    :request_url,
    :return_to,
    :transient_payload,
    :type,
    :ui
  ]

  @type t :: %__MODULE__{
          # :active => Kratos.Models.IdentityCredentialsType.t() | nil,
          :expires_at => DateTime.t(),
          :id => String.t(),
          :issued_at => DateTime.t(),
          # :oauth2_login_challenge => String.t() | nil,
          # :oauth2_login_request => Kratos.Models.OAuth2LoginRequest.t() | nil,
          :request_url => String.t(),
          :return_to => String.t() | nil,
          :transient_payload => map() | nil,
          :type => String.t(),
          :ui => Kratos.Models.UIContainer.t()
        }
end
