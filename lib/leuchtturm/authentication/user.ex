defmodule Leuchtturm.Authentication.User do
  @moduledoc """

  """

  alias Ecto.Changeset

  alias Leuchtturm.Authentication.User

  use Ecto.Schema

  import Ecto.Changeset

  @schema_prefix "authentication"
  @primary_key {:id, :binary_id, autogenerate: true}
  @timestamps_opts [type: :utc_datetime]
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime

    timestamps()
  end

  @type t :: %User{
          id: UUID.t() | nil,
          email: String.t() | nil,
          name: String.t() | nil,
          password: String.t() | nil,
          hashed_password: String.t() | nil,
          confirmed_at: DateTime.t() | nil
        }

  @doc """
  A user changeset for registration.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  @spec registration_changeset(User.t(), map(), keyword()) :: Changeset.t()
  def registration_changeset(%User{} = user, attrs, opts \\ []) do
    user
    |> cast(attrs, ~w/email password name/a)
    |> validate_required(~w/name/a)
    |> validate_email()
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  @spec confirm_changeset(User.t()) :: Ecto.Changeset.t()
  def confirm_changeset(user) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Argon2.no_user_verify/0` to avoid timing attacks.
  """
  @spec valid_password?(User.t(), String.t()) :: boolean()
  def valid_password?(%User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required(~w/email/a)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Invalid e-mail address.")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Leuchtturm.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required(~w/password/a)
    |> validate_length(:password, min: 12, max: 72)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end
end
