defmodule PlugGateway.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: PlugGateway.Router, options: [port: port()]}
    ]

    opts = [strategy: :one_for_one, name: PlugGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp port, do: (System.get_env("PORT") || "4000") |> String.to_integer
end
