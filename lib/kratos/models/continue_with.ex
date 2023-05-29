defmodule Kratos.Models.ContinueWith do
  @moduledoc false
  @derive {Nestru.Decoder, hint: %{flow: Kratos.Models.ContinueWithVerificationUIFlow}}
  defstruct [
    :action,
    :flow,
    :ory_session_token
  ]

  @type t :: %__MODULE__{
          :action => String.t(),
          :flow => Kratos.Models.ContinueWithVerificationUIFlow.t(),
          :ory_session_token => String.t()
        }
end
