defmodule PlugGateway.Router do
  @moduledoc """
  PlugGateway router.

  Should you copy from _this_ code?

  * Copy the use of `Plug.Telemetry` if you want `OpentelemetryPlug` to work. That aside, there's
    nothing in this module particularly relevant to tracing or metrics.

  * Copy the config pattern if you want `Vapor`'s `.env` and config file support, error messages
    _etc._ and don't mind the overhead. Otherwise, a `System.get_env/2` call in your
    `config/config.exs` and an `Application.get_env/2` call here will suffice.

  * Copy `use Norm` ... `@contract` if you prioritise rapid bug isolation over compact code.
  """

  use Plug.Router
  use Norm

  defdelegate config, to: PlugGateway.Config
  defdelegate get(url), to: PlugGateway.BackendClient

  # This specific event_prefix required for opentelemetry_plug at e750fd6 on update-name:
  plug(Plug.Telemetry, event_prefix: [:plug_adapter, :call])

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "Hello World")
  end

  get "/flakey" do
    if rem(System.system_time(:second), 2) == 0 do
      send_resp(conn, 200, "Success!")
    else
      send_resp(conn, 500, "Fail!")
    end
  end

  get "/users" do
    case get("/users") do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect(reason)}"}|)
    end
  end

  get "/users_n_plus_1" do
    case get("/users_n_plus_1") do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect(reason)}"}|)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
