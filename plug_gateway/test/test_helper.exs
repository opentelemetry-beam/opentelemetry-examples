Mox.defmock(PlugGateway.HTTPMock, for: PlugGateway.HTTP.API)
ExUnit.start(capture_log: true, timeout: 10_000, exclude: [:skip])
Application.ensure_all_started(:opentelemetry_api)
Application.ensure_all_started(:opentelemetry)
