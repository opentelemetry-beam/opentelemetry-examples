defmodule PlugGateway.HTTP.API do
  @moduledoc """
  PlugGateway API for speaking to HTTP back ends.

  Should you copy from _this_ code? The delegation pattern (`@callback`, `@behaviour`) has a few benefits
  over just making the call:

  * You can mock the external context for test purposes, which is useful in apps and packages; and

  * People taking a dependency on your package can replace the way you call that external context
    _eg._ to choose a different HTTP client package. This is less useful in apps.
  """

  @doc "Get a URL."
  @callback get(
              url :: String.t(),
              headers: [{String.t(), iodata()}]
            ) :: {:ok, integer(), String.t()} | {:error, term()}
end
