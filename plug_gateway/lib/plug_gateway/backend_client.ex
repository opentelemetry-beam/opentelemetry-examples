defmodule PlugGateway.BackendClient do
  @moduledoc """
  PlugGateway back end client.
  """

  def get(path) do
    config = PlugGateway.Config.get()
    url = config.api_endpoint <> path
    headers = [{"authorization", "Bearer #{config.auth_token}"}]
    config.http_module.get(url, headers)
  end
end
