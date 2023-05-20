defmodule Kratos.Models.GenericErrorResponse do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{error: Kratos.Models.GenericError}}
  defstruct [
    :error
  ]

  @type t :: %__MODULE__{
          :error => Kratos.Models.GenericError.t()
        }
end
