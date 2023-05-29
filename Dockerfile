ARG BUILDER_IMAGE="hexpm/elixir:1.14.5-erlang-26.0-ubuntu-jammy-20230126"
ARG RUNNER_IMAGE="ubuntu:jammy-20230126"

FROM ${BUILDER_IMAGE} as builder

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y build-essential git && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

WORKDIR /app
ENV MIX_ENV="prod"
ENV REQUIRE_VERSION_FILE="true"

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock version ./
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/
COPY assets assets/
COPY lib lib/
COPY priv priv/
COPY rel rel/

RUN mix do tailwind.install --if-missing, esbuild.install --if-missing
RUN mix do tailwind default --minify, esbuild default --minify, phx.digest
RUN mix compile

COPY config/runtime.exs config/
COPY rel ./

RUN mix release

FROM ${RUNNER_IMAGE}

RUN apt-get update -y && \
    apt-get install -y ca-certificates libstdc++6 openssl libncurses5 locales && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV MIX_ENV="prod"

WORKDIR /app
RUN chown nobody /app

COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/template ./

USER nobody

CMD ["/app/bin/start"]
