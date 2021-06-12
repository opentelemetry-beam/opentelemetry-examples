defmodule BasicElixir.Worker do
  use GenServer
  require Logger
  require OpenTelemetry.Tracer, as: Tracer
  require OpenTelemetry.Span, as: Span

  # Client
  def start_link(default) when is_list(default) do
    Tracer.with_span "start_link" do
      span_ctx = Tracer.current_span_ctx
      Span.set_attribute(span_ctx, "hello", "world")
      GenServer.start_link(__MODULE__, default)
    end
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (callbacks)
  @impl true
  def init(stack) do
    Tracer.with_span "init" do
      Logger.info("Starting #{__MODULE__}...")
      BasicElixir.hello()
      {:ok, stack}
    end
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
