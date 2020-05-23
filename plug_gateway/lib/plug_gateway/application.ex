defmodule PlugGateway.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = PlugGateway.Config.get().port

    children = [
      {Plug.Cowboy, scheme: :http, plug: PlugGateway.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: PlugGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
