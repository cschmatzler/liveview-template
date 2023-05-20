defmodule Kratos.Models.UINodeMeta do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{label: Kratos.Models.UIText}}
  defstruct [
    :label
  ]

  @type t :: %__MODULE__{
          :label => Kratos.Models.UIText.t() | nil
        }
end
