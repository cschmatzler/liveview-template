defmodule Kratos.Models.UINode do
  @moduledoc false

  @derive {Nestru.Decoder,
           hint: %{
             meta: Kratos.Models.UINodeMeta,
             attributes: Kratos.Models.UINodeAttributes,
             messages: [Kratos.Models.UIText]
           }}
  defstruct [
    :type,
    :meta,
    :group,
    :attributes,
    :messages
  ]

  @type t :: %__MODULE__{
          :type => String.t(),
          :meta => Kratos.Models.UINodeMeta.t(),
          :group => String.t(),
          :attributes => Kratos.Models.UINodeAttributes.t(),
          :messages => [Kratos.Models.UIText.t()]
        }
end
