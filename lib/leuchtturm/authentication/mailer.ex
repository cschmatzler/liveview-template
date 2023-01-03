defmodule Leuchtturm.Authentication.Mailer do
  alias Oban.Job

  alias Leuchtturm.Authentication
  alias Leuchtturm.Authentication.Mailer.Confirmation

  use Oban.Worker, queue: :mail

  import Swoosh.Email

  @from {"Leuchtturm.io", "hello@leuchtturm.io"}
  @confirmation_template_id 29_918_482
  @password_reset_template_id 1

  @type template_models :: Confirmation.t() | PasswordReset.t()

  defmodule Confirmation do
    alias Leuchtturm.Authentication.Mailer.Confirmation

    defstruct [:name, :confirmation_url]

    @type t :: %Confirmation{name: String.t(), confirmation_url: String.t()}
  end

  defmodule PasswordReset do
    alias Leuchtturm.Authentication.Mailer.PasswordReset

    defstruct [:name, :password_reset_url]

    @type t :: %PasswordReset{name: String.t(), password_reset_url: String.t()}
  end

  @impl Oban.Worker
  def perform(%Job{
        args: %{
          "mail_id" => "confirmation",
          "user_id" => user_id,
          "confirmation_token" => confirmation_token
        }
      }) do
    user = Authentication.get_user(user_id)

    template_model = %Confirmation{
      name: user.name,
      confirmation_url: "https://leuchtturm.io/confirm/#{confirmation_token}"
    }

    deliver(user.email, @confirmation_template_id, template_model)
  end

  @impl Oban.Worker
  def perform(%Job{
        args: %{
          "mail_id" => "password_reset",
          "user_id" => user_id,
          "password_reset_token" => password_reset_token
        }
      }) do
    user = Authentication.get_user(user_id)

    template_model = %PasswordReset{
      name: user.name,
      password_reset_url: "https://leuchtturm.io/forgot_password/#{password_reset_token}"
    }

    deliver(user.email, @confirmation_template_id, template_model)
  end

  @spec deliver(String.t(), integer(), template_models()) :: :ok | {:error, atom()}
  defp deliver(recipient, template_id, template_model) do
    new()
    |> from(@from)
    |> to(recipient)
    |> put_provider_option(:template_id, template_id)
    |> put_provider_option(:template_model, Map.from_struct(template_model))
    |> Leuchtturm.Mailer.deliver()
  end
end
