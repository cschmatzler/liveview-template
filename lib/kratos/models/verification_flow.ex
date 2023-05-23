defmodule Kratos.Models.VerificationFlow do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{ ui: Kratos.Models.UIContainer}}
  defstruct [
    # :active,
    :expires_at,
    :id,
    :issued_at,
    :request_url,
    :return_to,
    :state,
    :type,
    :ui
  ]

  @type t :: %__MODULE__{
          # :active => String.t() | nil,
          :expires_at => DateTime.t() | nil,
          :id => String.t(),
          :issued_at => DateTime.t() | nil,
          :request_url => String.t() | nil,
          :return_to => String.t() | nil,
          :state => String.t(),
          :type => String.t(),
          :ui => Kratos.Models.UIContainer.t()
        }
end
