defmodule Template.Auth.User do
  @moduledoc """
  Model for a user.

  Since we are exclusively using OAuth, this is a dumb copy of whatever information the external
  provider is giving us. There won't be any username/email and password authentication, allowing
  us a great deal of simplification.

  As of right now, a user model is never updated, even when parameters change on the side of the
  OAuth provider. This should be strongly reconsidered in the future, since, for example, email
  address changes can result in deliverability being broken.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Template.Auth.User

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "users" do
    field :provider, :string
    field :uid, :string
    field :email, :string
    field :name, :string
    field :image_url, :string
    field :role, Ecto.Enum, values: [:user, :admin], default: :user
    timestamps()
  end

  @type t :: %User{
          id: integer(),
          provider: String.t(),
          uid: String.t(),
          email: String.t(),
          name: String.t(),
          image_url: String.t() | nil
        }

  @doc """
  Builds a changeset for a user.
  """
  @spec changeset(%User{}, map()) :: Ecto.Changeset.t()
  def changeset(%User{} = user \\ %User{}, attrs) do
    user
    |> cast(attrs, [:provider, :uid, :email, :name, :image_url])
    |> validate_required([:provider, :uid, :email, :name])
  end

  @doc """
  Builds a query for fetching a user with OAuth provider and external UID.
  """
  @spec with_oauth_query(String.t(), String.t()) :: Ecto.Query.t()
  def with_oauth_query(provider, uid) do
    from(u in User,
      where: u.provider == ^provider,
      where: u.uid == ^uid
    )
  end

  @doc "Converts a user to a ConfigCat user."
  @spec to_configcat_user(User.t()) :: ConfigCat.User.t()
  def to_configcat_user(%User{} = user) do
    %ConfigCat.User{
      identifier: user.id,
      email: user.email,
      custom: %{role: user.role}
    }
  end
end
