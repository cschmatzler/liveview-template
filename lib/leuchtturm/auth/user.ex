defmodule Leuchtturm.Auth.User do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "users" do
    field :provider, :string
    field :uid, :string
    field :email, :string
    field :name, :string
    field :image_url, :string
    timestamps()
  end

  @type t :: %__MODULE__{
          id: integer(),
          provider: String.t(),
          uid: String.t(),
          email: String.t(),
          name: String.t(),
          image_url: String.t() | nil
        }

  def changeset(%__MODULE__{} = user \\ %__MODULE__{}, attrs) do
    user
    |> cast(attrs, [:provider, :uid, :email, :name, :image_url])
    |> validate_required([:provider, :uid, :email, :name])
  end

  def with_oauth_query(provider, uid) do
    from u in __MODULE__,
      where: u.provider == ^provider,
      where: u.uid == ^uid
  end
end
