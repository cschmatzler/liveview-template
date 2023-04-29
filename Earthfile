VERSION 0.7

ARG --global ELIXIR_VER=1.14.3
ARG --global OTP_VER=25.3.1
ARG --global ELIXIR_DEBIAN_VER=bullseye-20230227-slim
ARG --global DEBIAN_VER=bullseye-slim

ARG --global BUILD_BASE_IMAGE_NAME=hexpm/elixir
ARG --global BUILD_BASE_IMAGE_TAG=${ELIXIR_VER}-erlang-${OTP_VER}-debian-${ELIXIR_DEBIAN_VER}

ARG --global PROD_BASE_IMAGE_NAME=debian
ARG --global PROD_BASE_IMAGE_TAG=$DEBIAN_VER

ARG --global APP_NAME=liveview-template
ARG --global APP_DIR=/liveview-template

ARG --global APP_USER=nonroot
ARG --global APP_GROUP=$APP_USER
ARG --global APP_USER_ID=65532
ARG --global APP_GROUP_ID=$APP_USER_ID

build-base:
  FROM ${BUILD_BASE_IMAGE_NAME}:${BUILD_BASE_IMAGE_TAG}

  RUN set -exu && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install -y -qq --no-install-recommends \
      build-essential \
      ca-certificates \
      curl

  DO github.com/earthly/lib+INSTALL_DIND

  RUN sh -c "$(curl -L https://taskfile.dev/install.sh)" -- -d

build-deps:
  FROM +build-base

  ENV HOME=$APP_DIR
  WORKDIR $APP_DIR

  COPY --dir config ./
  COPY mix.exs mix.lock ./

  RUN mix 'do' local.hex --force, local.rebar --force
  RUN mix deps.get

prod-base:
  FROM ${PROD_BASE_IMAGE_NAME}:${PROD_BASE_IMAGE_TAG}

  ENV LANG=C.UTF-8

  RUN if ! grep -q "$APP_USER" /etc/passwd; \
    then groupadd -g "$APP_GROUP_ID" "$APP_GROUP" && \
    useradd -l -u "$APP_USER_ID" -g "$APP_GROUP" -s /usr/sbin/nologin "$APP_USER"; fi

  RUN set -exu && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install -y -qq --no-install-recommends \
      ca-certificates \
      locales && \
    locale-gen

  SAVE IMAGE --push ghcr.io/cschmatzler/liveview-template:prod-base

test-image:
  FROM +build-deps

  ENV MIX_ENV=test
  WORKDIR $APP_DIR

  RUN mix deps.compile
  RUN mix esbuild.install --if-missing
  RUN mix tailwind.install --if-missing

  COPY .formatter.exs .credo.exs .sobelow-conf Taskfile.yaml trivy.yaml ./
  COPY --dir lib priv test .taskfiles ./

  RUN mix compile --warnings-as-errors

  SAVE IMAGE --push ghcr.io/cschmatzler/liveview-template:test

release:
  FROM +build-deps

  ENV MIX_ENV=prod
  ENV REQUIRE_VERSION_FILE=true

  WORKDIR $APP_DIR

  COPY version .

  RUN mix deps.compile
  RUN mix esbuild.install --if-missing
  RUN mix tailwind.install --if-missing

  COPY Taskfile.yaml .
  COPY --dir .taskfiles assets lib priv rel ./

  RUN mix compile --warnings-as-errors
  RUN mix release
  RUN task ci:deploy-assets

  SAVE IMAGE --push ghcr.io/cschmatzler/liveview-template:release
  SAVE ARTIFACT _build/prod/rel/template /release

prod-image:
  BUILD +release
  BUILD +prod-base

  ARG --required IMAGE_TAG

  FROM +prod-base

  WORKDIR $APP_DIR
  USER $APP_USER

  COPY +release/release ./

  ENTRYPOINT ["bin/start"]

  SAVE IMAGE --push ghcr.io/cschmatzler/liveview-template:${IMAGE_TAG}

ci:
  BUILD +test-image
  BUILD +test
  BUILD +analyze

test:
  FROM +test-image

  COPY docker-compose.test.yaml ./docker-compose.yaml

  WITH DOCKER \
    --compose docker-compose.yaml \
    --service postgres
    RUN task ci:test
  END

  SAVE ARTIFACT cover/excoveralls.json AS LOCAL excoveralls-report.json

analyze:
  FROM +test-image

  RUN task ci:analyze
