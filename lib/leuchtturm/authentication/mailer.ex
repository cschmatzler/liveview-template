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

    template_model = %{
      name: user.name,
      email_confirmation_url: "https://leuchtturm.io/confirm/#{args["confirmation_token"]}"
    }

    deliver(user.email, @email_confirmation_template_id, template_model)
  end

  defp deliver(recipient, template_id, template_model) do
    new()
    |> from(@email_from)
    |> to(recipient)
    |> put_provider_option(:template_id, template_id)
    |> put_provider_option(:template_model, template_model)
    |> Leuchtturm.Mailer.deliver()
  end
end
