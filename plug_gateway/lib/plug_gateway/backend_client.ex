defmodule PlugGateway.BackendClient do
  @moduledoc """
  PlugGateway back end client.

  Should you copy from _this_ code?

  This module injects trace propagation headers so the next service can create new spans in the
  same trace. That's definitely worth doing. If you can't delegate that to your HTTP client
  package _eg._ `Tesla` with its `Plug`-like extension system, you need to do it yourself.

  This module also applies configuration from `PlugGateway.Config` before passing control to
  `PlugGateway.HTTP`. Merging its rssponsibilities into the latter would make it harder to mock
  and re-implement. You could move `get/1` to `PlugGateway.Router` until there was another caller,
  though.
  """

  defdelegate config, to: PlugGateway.Config
  defdelegate get(url, headers), to: PlugGateway.HTTP

  def get(path) do
    %{backend_api_endpoint: u, backend_auth_token: t} = config()
    url = u <> path

    headers =
      :ot_propagation.http_inject([
        {"authorization", "Bearer #{t}"}
      ])

    get(url, headers)
  end
end
