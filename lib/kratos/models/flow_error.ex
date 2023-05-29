defmodule Kratos.Models.FlowError do
  @moduledoc false

  @derive Nestru.Decoder
  defstruct [
    :id,
    :error,
    :created_at,
    :updated_at
  ]

  @type t :: %__MODULE__{
          :id => String.t(),
          :error => map() | nil,
          :created_at => DateTime.t() | nil,
          :updated_at => DateTime.t() | nil
        }
end
