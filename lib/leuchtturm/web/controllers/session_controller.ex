defmodule Leuchtturm.Web.SessionController do
  alias Leuchtturm.Authentication
  alias Leuchtturm.Web.Utilities.Authentication, as: WebAuthentication

  use Leuchtturm.Web, :controller

  def create(conn, %{"_action" => "register"} = params) do
    create(conn, params, "Account created successfully!")
  end

  def create(conn, params) do
    create(conn, params, "Welcome back!")
  end

  defp create(conn, %{"user" => attrs}, info) do
    %{"email" => email, "password" => password} = attrs

    if user = Authentication.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> WebAuthentication.login(user, attrs)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/login")
    end
  end

  def delete(conn, _params) do
    WebAuthentication.logout(conn)
  end
end
