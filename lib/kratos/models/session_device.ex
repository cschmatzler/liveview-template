defmodule Kratos.Models.SessionDevice do
  @moduledoc false

  @derive Nestru.Decoder
  defstruct [
    :id,
    :ip_address,
    :location,
    :user_agent
  ]

  @type t :: %__MODULE__{
          :id => String.t(),
          :ip_address => String.t() | nil,
          :location => String.t() | nil,
          :user_agent => String.t() | nil
        }
end
