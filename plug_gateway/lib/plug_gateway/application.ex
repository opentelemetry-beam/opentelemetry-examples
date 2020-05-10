defmodule PlugGateway.Application do
  @moduledoc """
  PlugGateway application.

  Should you copy from _this_ code? You'll need to call `OpentelemetryPlug.setup/2`, at least.
  """

  use Application
  use Norm

  @impl true
  def start(_type, _args) do
    :ok = OpentelemetryPlug.setup([:plug_gateway], [])

    port = PlugGateway.Config.config().port

    children = [
      {Plug.Cowboy, scheme: :http, plug: PlugGateway.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: PlugGateway.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
