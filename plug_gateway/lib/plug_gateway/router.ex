defmodule PlugGateway.Router do
  use Plug.Router

  alias PlugGateway.BackendClient

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
    case BackendClient.get("/users") do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect(reason)}"}|)
    end
  end

  get "/users_n_plus_1" do
    case BackendClient.get("/users_n_plus_1") do
      {:ok, status_code, body} -> send_resp(conn, status_code, body)
      {:error, reason} -> send_resp(conn, 502, ~s|{"errors":"#{inspect(reason)}"}|)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
