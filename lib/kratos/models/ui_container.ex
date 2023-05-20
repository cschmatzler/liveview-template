defmodule Kratos.Models.UIContainer do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{nodes: [Kratos.Models.UINode], messages: [Kratos.Models.UIText]}}
  defstruct [
    :action,
    :method,
    :nodes,
    :messages
  ]

  @type t :: %__MODULE__{
          :action => String.t(),
          :method => String.t(),
          :nodes => [Kratos.Models.UINode.t()],
          :messages => [Kratos.Models.UIText.t()] | nil
        }
end
