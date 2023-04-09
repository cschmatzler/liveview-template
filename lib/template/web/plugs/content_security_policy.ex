defmodule Template.Web.Plugs.ContentSecurityPolicy do
  @doc """
  This plug adds Phoenix secure HTTP headers including a
  “Content-Security-Policy” header to responses.You will need to customize each
  policy directive to fit your application needs.
  """

  @behaviour Plug

  import Phoenix.Controller, only: [put_secure_browser_headers: 2]

  def init(opts), do: opts

  def call(conn, _) do
    directives = [
      "default-src #{default_src_directive()}",
      "style-src #{style_src_directive()}",
      "font-src #{font_src_directive()}",
      "script-src #{script_src_directive()}",
      "img-src #{img_src_directive()}",
      "frame-src #{frame_src_directive()}",
      "connect-src #{connect_src_directive()}"
    ]

    put_secure_browser_headers(conn, %{"content-security-policy" => Enum.join(directives, "; ")})
  end

  defp default_src_directive, do: "'none'"
  defp style_src_directive, do: "'self' 'unsafe-inline' https://rsms.me"
  defp font_src_directive, do: "'self' https://rsms.me"
  defp script_src_directive, do: "'self'"
  defp img_src_directive, do: "'self' data:"
  defp frame_src_directive, do: "'self'"
  defp connect_src_directive, do: "'self'"
end
