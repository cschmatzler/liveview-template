defmodule Leuchtturm.Authentication do
  alias Ecto.Multi

  alias Leuchtturm.Repo
  alias Leuchtturm.Authentication.Mailer
  alias Leuchtturm.Authentication.{User, Token}

  @doc """
  Fetches a user from the database based on their ID.
  """
  @spec get_user(String.t()) :: User.t() | nil
  def get_user(id) when is_binary(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Fetches a user from the database based on their email address and password.
  Returns nil when the given password is incorrect.
  """
  @spec get_user_by_email_and_password(String.t(), String.t()) :: User.t() | nil
  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = get_user_by_email(email)
    if User.valid_password?(user, password), do: user
  end

  @spec get_user_by_session_token(String.t()) :: User.t() | nil
  def get_user_by_session_token(token) do
    Token.user_from_session_token_query(token)
    |> Repo.one()
  end

  @spec registration_changeset(User.t(), map()) :: Ecto.Changeset.t()
  def registration_changeset(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  @spec register(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()} | :error
  def register(attrs) do
    Multi.new()
    |> Multi.insert(:user, User.registration_changeset(%User{}, attrs, hash_password: true))
    |> Multi.run(:confirmation_token, fn _repo, %{user: user} ->
      create_confirmation_token(user)
    end)
    |> Multi.run(:confirmation_job, fn _repo, %{user: user, confirmation_token: token} ->
      create_confirmation_job(user, token)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} -> {:ok, user}
      {:error, :user, changeset, _} -> {:error, changeset}
      _ -> :error
    end
  end

  @spec create_confirmation_token(User.t()) :: binary()
  defp create_confirmation_token(user) do
    {token_string, token} = Token.build_email_token(user, "email_confirmation")
    Repo.insert!(token)

    token_string
  end

  @spec create_confirmation_job(User.t(), String.t()) :: Oban.Job.t()
  defp create_confirmation_job(user, confirmation_token) do
    Mailer.new(%{
      mail_id: "confirmation",
      user_id: user.id,
      confirmation_token: confirmation_token
    })
    |> Oban.insert!()
  end

  def send_password_reset_token(email) do
    user = get_user_by_email(email)

    case user do
      %User{} ->
        Multi.new()
        |> Multi.run(:password_reset_token, fn _repo, _ ->
          create_password_reset_token(user)
        end)
        |> Multi.run(:password_reset_job, fn _repo, %{password_reset_token: token} ->
          create_password_reset_job(user, token)
        end)
        |> Repo.transaction()

      nil ->
        {:error, :user_not_found}
    end
  end

  @spec create_password_reset_token(User.t()) :: {:ok, binary()}
  defp create_password_reset_token(user) do
    {token_string, token} = Token.build_email_token(user, "email_confirmation")
    Repo.insert!(token)

    {:ok, token_string}
  end

  @spec create_password_reset_job(User.t(), String.t()) :: {:ok, Oban.Job.t()}
  defp create_password_reset_job(user, password_reset_token) do
    job = Mailer.new(%{
      mail_id: "password_reset",
      user_id: user.id,
      password_reset_token: password_reset_token
    })
    |> Oban.insert!()

    {:ok, job}
  end

  @spec create_session_token(User.t()) :: binary()
  def create_session_token(user) do
    Token.build_session_token(user.id)
    |> Repo.insert!()
    |> then(& &1.token)
  end

  @spec delete_session_token(binary()) :: :ok
  def delete_session_token(token) do
    Token.token_and_purpose_query(token, "session")
    |> Repo.delete_all()

    :ok
  end
end
