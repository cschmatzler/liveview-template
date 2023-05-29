defmodule Kratos.Models.GenericError do
  @moduledoc false
  @derive Nestru.Decoder
  defstruct [
    :code,
    :debug,
    :details,
    :id,
    :message,
    :reason,
    :request,
    :status
  ]

  @type t :: %__MODULE__{
          :code => integer() | nil,
          :debug => String.t() | nil,
          :details => %{optional(String.t()) => AnyType} | nil,
          :id => String.t() | nil,
          :message => String.t(),
          :reason => String.t() | nil,
          :request => String.t() | nil,
          :status => String.t() | nil
        }
end
