# ============================================
# Multi-stage Dockerfile for Elixir development
#
# Build stages:
#   --target base : Base image with essential tools
#   --target dev  : Development environment (default)
#   --target prod : Production build environment
#
# Examples:
#   docker build --target dev -t myapp:dev .
#   docker build --target prod -t myapp:prod .
# ============================================

# ============================================
# Stage 1: Base
# Single source of truth for versions
# ============================================
FROM docker.io/hexpm/elixir:1.19.5-erlang-28.3-debian-trixie-20260202-slim AS base

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  build-essential git curl make \
  # When using Postgres uncomment the following line
  # libpq-dev postgresql-client\
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN mix local.hex --force && mix local.rebar --force

# ============================================
# Stage 2: Dev
# Development environment with interactive shell
# ============================================
FROM base AS dev

RUN apt-get update -qq && \
  apt-get install -y --no-install-recommends \
  erlang-crypto inotify-tools \
  && rm -rf /var/lib/apt/lists/*

COPY docker/app/run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]

# ============================================
# Stage 3: Prod
# Production build environment
# ============================================
FROM base AS prod

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  libstdc++6 openssl libncurses6 locales ca-certificates \
  && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV MIX_ENV=prod

# To use for production:
# 1. Uncomment to install dependencies:
# COPY mix.exs mix.lock ./
# RUN mix deps.get --only prod
# RUN mix deps.compile

# 2. Uncomment if your project has a config directory:
# COPY config/config.exs config/prod.exs config/

# 3. Uncomment if your project has assets:
# RUN mix assets.setup
# COPY assets assets
# COPY priv priv
# COPY lib lib

# 4. Uncomment to compile the application:
# RUN mix compile

# 5. Uncomment to build assets for production:
# RUN mix assets.deploy

# 6. Uncomment to build the release:
# COPY rel rel
# RUN mix release

# 7. Update CMD to match your app:
# CMD ["/app/bin/server"]
