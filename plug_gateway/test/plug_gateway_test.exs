defmodule PlugGatewayTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias PlugGateway.Router

  import Mox, only: [set_mox_from_context: 1, verify_on_exit!: 1]

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
    assert PlugGateway.Config.get().http_module == PlugGateway.HTTPMock
    set_mox_from_context(ctx)
    verify_on_exit!(ctx)

    test_pid = self()

    # Expect a call to PlugGateway.HTTPMock.get/2:
    Mox.expect(PlugGateway.HTTPMock, :get, fn url, headers ->
      try do
        # Did PlugGateway.BackendClient compose the full URL?
        assert url == "http://api.example.com/api/users"

        # Did PlugGateway.BackendClient inject the authorization header?
        assert {_, "Bearer BACKEND_AUTH_TOKEN"} = :lists.keyfind("authorization", 1, headers)

        # Send an event matching the exception smuggling below:
        send(test_pid, {:mock_result, :ok})

        # Reply:
        {:ok, 200, "yay"}
      rescue
        e ->
          # Smuggle the exception back to the test so you get full colour diffs on assert failure:
          send(test_pid, {:mock_result, :error, e, __STACKTRACE__})

          # Reply as if the server didn't like what we sent:
          {:ok, 400, "poot"}
      end
    end)

    result = get("/users")

    receive do
      {:mock_result, :ok} -> :ok
      {:mock_result, :error, e, stacktrace} -> reraise(e, stacktrace)
    end

    assert %{status: 200, resp_body: "yay"} = result
  end

  # Helpers

  defp get(path) do
    :get
    |> conn(path)
    |> Router.call(@router_opts)
  end
end
