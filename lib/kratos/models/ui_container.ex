defmodule Kratos.Models.UIContainer do
  @moduledoc false

  defimpl Nestru.PreDecoder do
    @optional_fields ~w(messages)

    def gather_fields_from_map(_value, _context, map) do
      map =
        Enum.reduce(@optional_fields, map, fn field, map ->
          Map.update(map, field, [], &if(is_nil(&1), do: [], else: &1))
        end)

      {:ok, map}
    end
  end

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
