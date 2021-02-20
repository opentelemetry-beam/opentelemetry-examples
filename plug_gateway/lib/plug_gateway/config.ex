defmodule PlugGateway.Config do
  @moduledoc """
  PlugGateway configuration.
  """

  defstruct [:api_endpoint, :auth_token, http_module: PlugGateway.HTTP.API.Poisonous, port: 4000]

  @doc "Get our configuration."
  def get do
    config = struct!(__MODULE__, Application.get_all_env(:plug_gateway))

    if not is_binary(config.api_endpoint), do: raise("BACKEND_API_URL missing")
    if not is_binary(config.auth_token), do: raise("BACKEND_AUTH_TOKEN missing")

    config
  end
end
