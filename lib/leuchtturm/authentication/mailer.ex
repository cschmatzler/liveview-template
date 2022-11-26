defmodule Leuchtturm.Authentication.Mailer do
  alias Oban.Job

  alias Leuchtturm.Authentication
  alias Leuchtturm.Mailer

  use Oban.Worker, queue: :mail

  import Swoosh.Email

  @email_from {"Leuchtturm.io", "hello@leuchtturm.io"}
  @email_confirmation_template_id 29_918_482

  @impl Oban.Worker
  def perform(%Job{args: %{"mail_id" => "email_confirmation"} = args}) do
    user = Authentication.get_user(args["user_id"])

    new()
    |> from(@email_from)
    |> to({user.name, user.email})
    |> put_provider_option(:template_id, @email_confirmation_template_id)
    |> put_provider_option(:template_model, %{
      name: user.name,
      email_confirmation_url: "https://leuchtturm.io/confirm/#{args["confirmation_token"]}"
    })
    |> Leuchtturm.Mailer.deliver()
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """

    ==============================

    Hi #{user.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Leuchtturm", "hello@leuchtturm.io"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end
end
