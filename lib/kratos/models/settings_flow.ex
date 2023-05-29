defmodule Kratos.Models.SettingsFlow do
  @moduledoc false
  defimpl Nestru.PreDecoder do
    @optional_fields ~w(continue_with)

    def gather_fields_from_map(_value, _context, map) do
      map =
        Enum.reduce(@optional_fields, map, fn field, map ->
          Map.update(map, field, [], &if(is_nil(&1), do: [], else: &1))
        end)

      {:ok, map}
    end
  end

  @derive {Nestru.Decoder,
           hint: %{
             continue_with: [Kratos.Models.ContinueWith],
             ui: Kratos.Models.UIContainer,
             identity: Kratos.Models.Identity
           }}
  defstruct [
    :active,
    :continue_with,
    :expires_at,
    :id,
    :identity,
    :issued_at,
    :request_url,
    :return_to,
    :state,
    :type,
    :ui
  ]

  @type t :: %__MODULE__{
          :active => String.t() | nil,
          :continue_with => [Kratos.Models.ContinueWith.t()] | nil,
          :expires_at => DateTime.t(),
          :id => String.t(),
          :identity => Kratos.Models.Identity.t(),
          :issued_at => DateTime.t(),
          :request_url => String.t(),
          :return_to => String.t() | nil,
          :state => Kratos.Models.SettingsFlowState.t(),
          :type => String.t(),
          :ui => Kratos.Models.UIContainer.t()
        }
end
