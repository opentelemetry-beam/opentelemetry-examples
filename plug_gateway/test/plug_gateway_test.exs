defmodule PlugGatewayTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias PlugGateway.Router

  import Mox, only: [set_mox_from_context: 1, verify_on_exit!: 1]

  require OpenTelemetry.Tracer

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

  test "users route to back end", ctx do
    assert PlugGateway.HTTP.implementation() == PlugGateway.HTTPMock
    set_mox_from_context(ctx)
    verify_on_exit!(ctx)

    Mox.expect(PlugGateway.HTTPMock, :get, fn url, headers ->
      try do
        # did PlugGateway.BackendClient compose the full URL?
        assert url == "http://localhost:4001/api/users"

        # did PlugGateway.BackendClient inject the authorization header?
        assert {_, "Bearer BEAM me up!"} = :lists.keyfind("authorization", 1, headers)
        # did PlugGateway.BackendClient inject the traceparent header?
        assert {_, tp_iodata} = :lists.keyfind("traceparent", 1, headers)

        assert IO.iodata_to_binary(tp_iodata) =~
                 ~R/^[0-9a-f]{2,2}-[0-9a-f]{32,32}-[0-9a-f]{16,16}-[0-9a-f]{2,2}$/

        {:ok, 200, "poot"}
      rescue
        # TODO change this pattern up a little so assert error messages will stay tidy.
        e -> {:error, e}
      end
    end)

    assert %{status: 200, resp_body: "poot"} = get("/users")
  end

  # Helpers

  defp get(path) do
    :get
    |> conn(path)
    |> Router.call(@router_opts)
  end
end
