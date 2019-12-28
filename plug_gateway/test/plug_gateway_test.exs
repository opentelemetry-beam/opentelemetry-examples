defmodule PlugGatewayTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias PlugGateway.Router

  @router_opts Router.init([])

  test "root endpoint" do
    conn = get("/")

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "Hello World"
  end

  test "flakey endpoint" do
    conn = get("/flakey")

    assert conn.state == :sent
    assert {conn.status, conn.resp_body} in [{200, "Success!"}, {500, "Fail!"}]
  end

  test "catch-all route" do
    conn = get("/bogus")

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Not Found"
  end

  # Helpers

  defp get(path) do
    :get
    |> conn(path)
    |> Router.call(@router_opts)
  end
end
