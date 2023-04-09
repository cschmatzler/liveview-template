defmodule Template.Auth.AuthImplTest do
  use Template.DataCase, async: true
  use Hammox.Protect, module: Template.Auth.Impl, behaviour: Template.Auth

  import Template.Fixtures.Auth

  alias Template.Auth.Impl, as: Auth
  alias Template.Auth.Token
  alias Template.Auth.User

  setup do
    {token, user} = token_fixture()

    %{user: user, token: token}
  end

  describe "get_user_with_oauth/2" do
    test "returns a user with the given OAuth provider and UID", %{user: user} do
      result = Auth.get_user_with_oauth(user.provider, user.uid)

      assert result == user
    end

    test "returns nil if the combination of OAuth provider and UID does not exist" do
      provider = "unknown_provider"
      uid = "0"

      result = Auth.get_user_with_oauth(provider, uid)

      assert is_nil(result)
    end
  end

  describe "get_user_with_token/1" do
    test "returns the user belonging to the token if the token is valid and not expired", %{
      token: token,
      user: user
    } do
      result = Auth.get_user_with_token(token.token)

      assert result == user
    end

    test "returns nil if the token is invalid" do
      result = Auth.get_user_with_token("invalid_token")

      assert is_nil(result)
    end

    test "returns nil if the token is valid, but expired", %{token: token} do
      expired_date =
        DateTime.utc_now()
        |> DateTime.add(-Token.session_validity_in_days(), :day)
        |> DateTime.truncate(:second)

      Ecto.Changeset.change(token, inserted_at: expired_date) |> Repo.update!()

      result = Auth.get_user_with_token(token.token)

      assert is_nil(result)
    end
  end

  describe "create_user/5" do
    test "returns a user" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      {:ok, result} = Auth.create_user(provider, uid, email, name, image_url)

      assert %User{} = result
    end

    test "returns a struct with the OAuth provider, UID, email, name, and image url" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      {:ok, result} = Auth.create_user(provider, uid, email, name, image_url)

      assert result.provider == provider
      assert result.uid == uid
      assert result.email == email
      assert result.name == name
      assert result.image_url == image_url
    end

    test "it returns an error when OAuth provider is nil" do
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(nil, uid, email, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).provider
    end

    test "it raises when UID is nil" do
      provider = "google"
      email = "google_user@example.com"
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, nil, email, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).uid
    end

    test "it raises when email is nil" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      name = "Google User"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, uid, nil, name, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).email
    end

    test "it raises when name is nil" do
      provider = "google"
      uid = make_ref() |> :erlang.ref_to_list() |> List.to_string()
      email = "google_user@example.com"
      image_url = "https://example.com/image.jpg"

      result = Auth.create_user(provider, uid, email, nil, image_url)

      assert {:error, %Ecto.Changeset{} = changeset} = result
      assert errors_on(changeset).name
    end
  end

  describe "create_token!/1" do
    test "returns a token", %{user: user} do
      token = Auth.create_token!(user.id)

      assert %Token{} = token
    end

    test "returns a struct with a random token string", %{user: user} do
      token = Auth.create_token!(user.id)

      assert byte_size(token.token) == Token.token_size()
    end

    test "returns a struct referencing the given UID", %{user: user} do
      token = Auth.create_token!(user.id)

      assert token.user_id == user.id
    end
  end

  describe "delete_token/1" do
    test "deletes the token token belonging to the given token string from the database", %{
      token: token
    } do
      assert Repo.all(Token) |> length() == 1
      assert :ok = Auth.delete_token(token.token)
      assert Repo.all(Token) |> length() == 0
    end

    test "returns :ok even if the given token string does not exist" do
      assert :ok = Auth.delete_token("invalid_token")
    end
  end
end
