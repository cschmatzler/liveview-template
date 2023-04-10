defmodule Template.Web.Live.Auth do
  import Template.Web.Auth, only: [signed_out_path: 0]

  @doc """
  Mount actions for LiveViews and live sessions that interact with authentication.

  ## `:mount_user`

  Mounts the session user from the initial connection as `assigns.user`.

  ## `:redirect_if_unauthenticated`

  If no valid authenticated session exists, halts the mount and redirects to `signed_out_path/0`.
  Most likely to be used together with `:mount_user`.

  ## `:require_admin`

  If no valid authenticated session exists, or the authenticated user is not an admin, halts the
  mount and redirects to `signed_out_path/0`. Most likely to be used together with `:mount_user`.

  ## Usage
      # Router
      live_session :authenticated,
      on_mount: [
        {Template.Web.Live.Auth, :mount_user},
        {Template.Web.Live.Auth, :redirect_if_authenticated}
      do
        scope "/", Template.Web do
          pipe_through :browser

          live "/profile", UserLive.Profile, :index
        end
      end
  """
  def on_mount(:mount_user, _params, session, socket) do
    socket = mount_user(session, socket)

    {:cont, socket}
  end

  def on_mount(:require_session, _params, _session, socket) do
    if Map.get(socket.assigns, :user) do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_out_path())}
    end
  end

  def on_mount(:require_admin, _params, _session, socket) do
    with user when not is_nil(user) <- Map.get(socket.assigns, :user),
         :admin <- user.role do
      {:cont, socket}
    else
      _ ->
        {:halt, Phoenix.LiveView.redirect(socket, to: signed_out_path())}
    end
  end

  defp mount_user(session, socket) do
    case session do
      %{"session_token" => session_token} ->
        Phoenix.Component.assign_new(socket, :user, fn ->
          Template.Auth.get_user_with_token(session_token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :user, fn -> nil end)
    end
  end
end
