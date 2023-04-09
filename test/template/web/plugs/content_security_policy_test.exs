defmodule Template.Web.Plugs.ContentSecurityPolicyTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias Template.Web.Plugs.ContentSecurityPolicy

  @opts ContentSecurityPolicy.init([])

  test "sets the content-security-policy header" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    assert List.keyfind(conn.resp_headers, "content-security-policy", 0)
  end

  test "sets the default-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "default-src"
  end

  test "sets the style-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "style-src"
  end


  test "sets the script-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "script-src"
  end

  test "sets the img-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "img-src"
  end


  test "sets the frame-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "frame-src"
  end


  test "sets the connect-src directive" do
    conn = conn(:get, "/")
    conn = ContentSecurityPolicy.call(conn, @opts)

    directives = List.keyfind(conn.resp_headers, "content-security-policy", 0) |> elem(1)

    assert directives =~ "connect-src"
  end
end
