defmodule Template.Mailer do
  @moduledoc false

  use Boundary, deps: [], exports: [], top_level?: true
  use Swoosh.Mailer, otp_app: :template
end
