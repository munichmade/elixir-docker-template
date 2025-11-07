ARG ELIXIR_VERSION=1.19.2
ARG OTP_VERSION=28.1
ARG DEBIAN_VERSION=trixie-20251103-slim

ARG DEV_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"

FROM ${DEV_IMAGE}
# Install basic dependencies see https://medium.com/@ricardo.trindade743/setting-up-phoenix-postgresql-with-docker-compose-for-local-development-afeb4a4ace6c
RUN apt-get update -qq && \
  apt-get -y --allow-unauthenticated install\
  build-essential\
  curl\
  # libpq-dev\
  # postgresql-client\
  git\
  make\
  erlang-crypto\
  inotify-tools\
  apt-transport-https

RUN mkdir /app
WORKDIR /app

RUN mix local.hex --force \
  && mix local.rebar --force \
  # && mix archive.install hex phx_new --force \
  && echo

COPY run.sh /

