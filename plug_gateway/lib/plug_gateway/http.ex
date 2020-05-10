defmodule PlugGateway.HTTP do
  @moduledoc """
  PlugGateway front door for speaking to HTTP back ends.

  Implements `PlugGateway.HTTP.API`.
  Delegates at run-time to the module returned by `implementation/0`.

  Should you copy from _this_ code? See `PlugGateway.HTTP.API` for the `@behaviour` pattern.
  Copy `use Norm` ... `@contract` if you prioritise rapid bug isolation over compact code.
  Consider how handy the contract check would be if you were implementing the behaviour yourself.
  Not so much? Not so much.
  """

  @behaviour PlugGateway.HTTP.API

  use Norm

  @doc """
  `Norm` spec for `t:iodata/0`.

  Should you copy from _this_ code? It's expensive, but you'll only be running it for the headers.
  Maybe you'd compile it in differently if we were building a production release. If you're not
  sure how: no, you probably shouldn't copy this code.
  """
  def iodata,
    do:
      spec(
        is_binary() or
          fn iodata ->
            try do
              IO.iodata_length(iodata) >= 0
            rescue
              _ in ArgumentError -> false
            end
          end
      )

  @contract get(
              url :: spec(is_binary()),
              headers :: coll_of({spec(is_binary()), iodata()})
            ) ::
              one_of([
                {:ok, spec(is_integer()), spec(is_binary())},
                {:error, spec(fn _ -> true end)}
              ])
  @doc """
  Delegate to the configured `c:PlugGateway.HTTP.API.get/1`.
  """
  @impl true
  def get(url, headers) do
    implementation().get(url, headers)
  end

  @doc """
  Get the configured implementation.
  """
  @spec implementation() :: module()
  def implementation,
    do: Application.get_env(:plug_gateway, :http, PlugGateway.HTTP.Poisonous)
end
