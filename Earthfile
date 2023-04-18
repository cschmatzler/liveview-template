VERSION 0.7

setup-base:
   ARG ELIXIR=1.14.4
   ARG ERLANG=25.3
   ARG ALPINE=3.17.2
   FROM hexpm/elixir:$ELIXIR-erlang-$ERLANG-alpine-$ALPINE
   RUN apk add --no-progress --update git build-base
   ENV ELIXIR_ASSERT_TIMEOUT=10000
   WORKDIR /src
