defmodule Kratos.Models.SessionAuthenticationMethod do
  @moduledoc false
  @derive Jason.Encoder
  defstruct [
    :aal,
    :completed_at,
    :method
  ]

  @type t :: %__MODULE__{
          :aal => String.t(),
          :completed_at => DateTime.t() | nil,
          :method => String.t() | nil
        }
end
