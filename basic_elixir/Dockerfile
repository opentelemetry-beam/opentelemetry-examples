FROM elixir:1.9-alpine as builder
# Add git as deps to fetch dependencies through git directly
RUN apk add git
RUN mix local.hex --force && mix local.rebar --force
WORKDIR /app
COPY . /app
RUN mix deps.get
# Need to compile opentelemetry_api first, else will
# face compilation error when trying to compile opentelemetry
# with the following trace:
#
# ===> Compiling opentelemetry
# ===> Compiling src/otel_sampler.erl failed
# src/otel_sampler.erl:29: can't find include lib "opentelemetry_api/include/opentelemetry.hrl"
# src/otel_sampler.erl:85: undefined macro 'IS_SPAN_ENABLED/1'
# src/otel_sampler.erl:100: undefined macro 'IS_SPAN_ENABLED/1'
RUN mix deps.compile opentelemetry_api \
  && mix deps.compile opentelemetry \
  && mix deps.compile \
  && MIX_ENV=prod mix release

FROM alpine:latest as app
RUN apk add bash openssl
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/basic_elixir .
CMD bin/basic_elixir start

