defmodule Kratos.Models.RecoveryFlow do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{ui: Kratos.Models.UIContainer}}
  defstruct [
    :active,
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
          :active => String.t() | nil,
          :expires_at => DateTime.t(),
          :id => String.t(),
          :issued_at => DateTime.t(),
          :request_url => String.t(),
          :return_to => String.t() | nil,
          :state => String.t(),
          :type => String.t(),
          :ui => Kratos.Models.UIContainer.t()
        }
end
