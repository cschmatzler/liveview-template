defmodule Kratos.Models.ContinueWithVerificationUIFlow do
  @moduledoc false
  @derive Nestru.Decoder
  defstruct [
    :id,
    :url,
    :verifiable_address
  ]

  @type t :: %__MODULE__{
          :id => String.t(),
          :url => String.t() | nil,
          :verifiable_address => String.t()
        }
end
