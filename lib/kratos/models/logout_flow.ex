defmodule Kratos.Models.LogoutFlow do
  @moduledoc false
  @derive Nestru.Decoder
  defstruct [
    :logout_token,
    :logout_url
  ]

  @type t :: %__MODULE__{
          :logout_token => String.t(),
          :logout_url => String.t()
        }
end
