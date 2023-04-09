Hammox.defmock(AuthMock, for: Template.Auth)
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Template.Repo, :manual)
