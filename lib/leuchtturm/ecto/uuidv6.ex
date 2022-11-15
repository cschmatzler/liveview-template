defmodule Leuchtturm.Ecto.UUIDv6 do
  @moduledoc """
  Ecto Type to autogenerate UUIDv6 for use in schemas.

  We are using UUIDv6 for our primary keys because it is guaranteed
  to create IDs in sequential order, allowing our database to more
  easily index the records.
  """

  use Ecto.Type

  def type, do: :binary_id
  def cast(uuid), do: {:ok, uuid}
  def dump(uuid), do: {:ok, uuid}
  def load(uuid), do: {:ok, uuid}
  def autogenerate, do: Uniq.UUID.uuid6(:raw)

  @type t() :: Uniq.UUID.t()
end
