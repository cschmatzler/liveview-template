defmodule Kratos.Models.UINodeAttributes do
  @moduledoc false

  @derive {Nestru.Decoder, hint: %{label: Kratos.Models.UIText, text: Kratos.Models.UIText, title: Kratos.Models.UIText}}
  defstruct [
    :async,
    :autocomplete,
    :crossorigin,
    :disabled,
    :height,
    :href,
    :id,
    :integrity,
    :label,
    :name,
    :node_type,
    :nonce,
    :onclick,
    :pattern,
    :referrerpolicy,
    :required,
    :src,
    :text,
    :title,
    :type,
    :value,
    :width,
  ]

  @type t :: %__MODULE__{
          :async => boolean(),
          :autocomplete => String.t() | nil,
          :crossorigin => String.t(),
          :disabled => boolean(),
          :height => integer(),
          :href => String.t(),
          :id => String.t(),
          :integrity => String.t(),
          :label => Kratos.Models.UIText.t() | nil,
          :name => String.t(),
          :node_type => String.t(),
          :nonce => String.t(),
          :onclick => String.t() | nil,
          :pattern => String.t() | nil,
          :referrerpolicy => String.t(),
          :required => boolean() | nil,
          :src => String.t(),
          :text => Kratos.Models.UIText.t(),
          :title => Kratos.Models.UIText.t(),
          :type => String.t(),
          :value => AnyType | nil,
          :width => integer(),
        }
end
