defmodule Kratos.Models.LoginFlow do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{ui: Kratos.Models.UIContainer}}
  defstruct [
    :id,
    :active,
    # :oauth2_login_challenge,
    # :oauth2_login_request,
    :type,
    :requested_aal,
    :refresh,
    :request_url,
    :return_to,
    :ui,
    :created_at,
    :updated_at,
    :issued_at,
    :expires_at
  ]

  @type t :: %__MODULE__{
          :id => String.t(),
          :active => String.t() | nil,
          # :oauth2_login_challenge => String.t() | nil,
          # :oauth2_login_request => Kratos.Models.OAuth2LoginRequest.t() | nil,
          :type => String.t(),
          :requested_aal => String.t(),
          :refresh => boolean() | nil,
          :request_url => String.t(),
          :return_to => String.t() | nil,
          :ui => Kratos.Models.UIContainer.t(),
          :created_at => DateTime.t() | nil,
          :updated_at => DateTime.t() | nil,
          :issued_at => DateTime.t(),
          :expires_at => DateTime.t()
        }
end
