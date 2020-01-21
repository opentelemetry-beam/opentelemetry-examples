FROM elixir:1.9-alpine as builder
RUN mix local.hex --force && mix local.rebar --force
WORKDIR /app
COPY . /app
RUN mix deps.get
RUN MIX_ENV=prod mix release

FROM alpine:latest
RUN apk add bash openssl
WORKDIR /app
COPY --from=builder /app/_build/prod/rel/phoenix_backend/ .
CMD bin/phoenix_backend start
ENV PORT 80
EXPOSE $PORT
