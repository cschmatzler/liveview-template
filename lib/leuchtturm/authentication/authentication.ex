defmodule Leuchtturm.Authentication do
  alias Ecto.Multi

  alias Leuchtturm.Repo
  alias Leuchtturm.Authentication.Mailer
  alias Leuchtturm.Authentication.{User, Token}

  def get_user(id) do
    Repo.get(User, id)
  end

  @spec get_user_by_email_and_password(String.t(), String.t()) :: User.t() | nil
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if User.valid_password?(user, password), do: user
  end

  @spec registration_changeset(User.t(), map()) :: Ecto.Changeset.t()
  def registration_changeset(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  @spec register(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()} | :error
  def register(attrs) do
    # FIXME: this is the biggest mess ever.
    Multi.new()
    |> Multi.insert(:user, User.registration_changeset(%User{}, attrs))
    |> Multi.run(:confirmation_token, fn _repo, %{user: user} ->
      {token_string, token} = Token.build_email_token(user, "email_confirmation")

      case Repo.insert(token) do
        {:ok, _token} -> {:ok, token_string}
        {:error, reason} -> {:error, reason}
      end
    end)
    |> Multi.run(:email_confirmation_job, fn _repo,
                                             %{user: user, confirmation_token: confirmation_token} ->
      Mailer.new(%{
        mail_id: "email_confirmation",
        user_id: user.id,
        confirmation_token: confirmation_token
      })
      |> Oban.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
      _ -> :error
    end
  end

  @spec generate_user_session_token(User.t()) :: String.t()
  def generate_user_session_token(user) do
    {token_string, token} = Token.build_session_token(user)
    Repo.insert!(token)

    token_string
  end
end
