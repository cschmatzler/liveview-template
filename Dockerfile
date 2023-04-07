ARG BASE_OS=alpine

ARG ELIXIR_VER=1.14.4
ARG OTP_VER=25.3
ARG BUILD_OS_VER=3.17.2
ARG PROD_OS_VER=$BUILD_OS_VER

ARG BUILD_BASE_IMAGE_NAME=hexpm/elixir
ARG BUILD_BASE_IMAGE_TAG=${ELIXIR_VER}-erlang-${OTP_VER}-${BASE_OS}-${BUILD_OS_VER}
ARG PROD_BASE_IMAGE_NAME=${BASE_OS}
ARG PROD_BASE_IMAGE_TAG=$PROD_OS_VER

ARG APP_NAME=template
ARG RELEASE=template
ARG APP_DIR=/app

ARG APP_USER=nonroot
ARG APP_GROUP=$APP_USER
ARG APP_USER_ID=65532
ARG APP_GROUP_ID=$APP_USER_ID

ARG LANG=C.UTF-8

ARG MIX_ENV=prod

FROM ${BUILD_BASE_IMAGE_NAME}:${BUILD_BASE_IMAGE_TAG} AS build-os-deps
    ARG LANG
    ENV LANG=$LANG

    ARG APP_DIR
    ARG APP_USER
    ARG APP_GROUP
    ARG APP_USER_ID
    ARG APP_GROUP_ID

    RUN if ! grep -q "$APP_USER" /etc/passwd; \
        then addgroup -g "$APP_GROUP_ID" -S "$APP_GROUP" && \
        adduser -u "$APP_USER_ID" -S "$APP_USER" -G "$APP_GROUP" -h "$APP_DIR"; fi

    RUN --mount=type=cache,id=apk,target=/var/cache/apk,sharing=locked \
        set -exu && \
        ln -s /var/cache/apk /etc/apk/cache && \
        apk add --no-progress nodejs npm && \
        apk add --no-progress openssh && \
        apk add --no-progress just && \
        apk add --no-progress git build-base

FROM build-os-deps AS build-deps-get
    ARG APP_DIR

    WORKDIR $APP_DIR

    COPY config ./config
    COPY mix.exs .
    COPY mix.lock .

    RUN mix 'do' local.rebar --force, local.hex --force
    RUN mix deps.get

FROM build-deps-get AS test-image
    ARG APP_DIR

    ENV MIX_ENV=test

    WORKDIR $APP_DIR

    RUN mix deps.compile
    RUN mix esbuild.install --if-missing

    COPY .formatter.exs coveralls.jso[n] .credo.ex[s] ./
    COPY priv ./priv
    COPY lib ./lib
    COPY test ./test

    RUN mix compile --warnings-as-errors

FROM build-deps-get AS prod-release
    ARG APP_DIR
    ARG RELEASE
    ARG MIX_ENV=prod

    WORKDIR $APP_DIR

    RUN mix deps.compile

    RUN mix esbuild.install --if-missing

    COPY assets ./assets
    COPY priv ./priv
    COPY lib ./lib
    COPY justfile ./

    RUN just deploy-assets
    RUN mix compile --warnings-as-errors

    COPY rel ./rel
    RUN mix release "$RELEASE"

FROM ${PROD_BASE_IMAGE_NAME}:${PROD_BASE_IMAGE_TAG} AS prod-base
    ARG LANG
    ENV LANG=$LANG

    ARG APP_DIR
    ARG APP_USER
    ARG APP_GROUP
    ARG APP_GROUP_ID
    ARG APP_USER_ID

    RUN if ! grep -q "$APP_USER" /etc/passwd; \
        then addgroup -g $APP_GROUP_ID -S "$APP_GROUP" && \
        adduser -u $APP_USER_ID -S "$APP_USER" -G "$APP_GROUP" -h "$APP_DIR"; fi

    RUN --mount=type=cache,id=apk,target=/var/cache/apk,sharing=locked \
        set -ex && \
        ln -s /var/cache/apk /etc/apk/cache && \
        apk add --no-progress ca-certificates && \
        apk add --no-progress ncurses-libs libgcc libstdc++

FROM prod-base AS prod
    ARG APP_DIR
    ARG APP_NAME
    ARG APP_USER
    ARG APP_GROUP
    ARG APP_PORT

    ARG MIX_ENV
    ARG RELEASE

    ENV HOME=$APP_DIR \
        PORT=$APP_PORT \
        PHX_SERVER=true \
        MIX_ENV=$MIX_ENV \
        RELEASE_TMP="/run/${APP_NAME}"

    RUN \
        mkdir -p "/run/${APP_NAME}" && \
        chown -R "${APP_USER}:${APP_GROUP}" \
            "/run/${APP_NAME}"

    WORKDIR $APP_DIR

    USER $APP_USER

     COPY --from=prod-release --chown="$APP_USER:$APP_GROUP" "/app/_build/${MIX_ENV}/rel/${RELEASE}" ./

    EXPOSE $APP_PORT

    ENTRYPOINT ["bin/$RELEASE"]

    CMD ["start"]

FROM prod
