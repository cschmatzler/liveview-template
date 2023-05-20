defmodule Kratos.Models.UIText do
  @moduledoc false

  @derive Nestru.Decoder
  defstruct [
    :id,
    :type,
    :context,
    :text
  ]

  @type t :: %__MODULE__{
          :id => integer(),
          :type => String.t(),
          :context => map() | nil,
          :text => String.t()
        }
end
