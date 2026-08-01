# Elixir Docker Template

This template contains the boilerplate to setup an Elixir application via
Docker.

## Motivation

As Elixir (as well as other languages) has different versions and prerequisites
this template should help being able to have multiple versions at once. There
are other ways like f.e. `asdf` to achieve this but for quickly checking out a
project for instance Docker is a nice solution.

Further this should help to get other people onboarded more easily as the stack
specifics are "hidden" by Docker.

Lastly the ability to develop under a production alike system environment might
help to miss some hurdles.

## Features

- Docker based environment for Elixir / Erlang
- `justfile` for easier handling of the stack
- Multi-stage Dockerfile for dev and production builds

## Prerequisites

You need to have the following installed:

- [Docker](https://docker.io) for running the code
- [Just](https://just.systems) for running commands

## Docker Build

The template uses a single `docker/Dockerfile` with multiple build stages:

| Stage | Purpose |
|-------|---------|
| `base` | Base image with essential tools |
| `dev` | Development environment (default) |
| `prod` | Production build environment |

### Build Commands

```bash
# Development (via compose)
just start

# Production
docker build --target prod -t myapp:prod .
```

The versions are defined in the `FROM` statement in the base stage (currently Elixir 1.20.2, Erlang 29.0.3, Debian trixie).

### Optimized Production Build

For a smaller production image, you can use a two-stage build pattern. Create a separate `Dockerfile.prod` based on the template's commented sections:

```dockerfile
# Stage 1: Builder
FROM docker.io/hexpm/elixir:1.20.2-erlang-29.0.3-debian-trixie-20260713-slim AS builder

WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod
RUN mix deps.compile

COPY config/ config/
COPY lib/ lib/
COPY priv/ priv/
RUN mix compile

COPY rel/ rel/
RUN mix release

# Stage 2: Runtime
FROM debian:trixie-20260713-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
  libstdc++6 openssl libncurses6 locales ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
WORKDIR /app

COPY --from=builder /app/_build/prod/rel/your_app ./
CMD ["./bin/server"]
```

## Usage

To use the template either download the files and augment an existing project
or use this template as a starting point.

Per default the template does start an IEx session without anything else.

### Initialize and create a project

>If you need PostreSQL you first need to uncomment the parts in `compose.yaml`

You can run `just create` to setup a Mix project. This will open an empty
`${EDITOR}` instance, e.g. Neovim where you can add the installer command.

```bash
mix archive.install hex igniter_new --force
mix archive.install hex phx_new 1.8.9 --force

mix igniter.new req_is_life --with phx.new --with-args "--database sqlite3" \
  --install ash,ash_phoenix --install ash_sqlite,ash_authentication \
  --install ash_authentication_phoenix,ash_oban \
  --install oban_web,live_debugger --install usage_rules \
  --auth-strategy password --setup --yes
```

This will install Ash with some extensions and Phoenix. The result in the
example will be placed in the folder `req_is_life`. However it might not be
desirable to have a separate folder. Unfortunately `igniter` does not allow
installing in non-empty folders. To overcome this limitation you can add

```bash
shopt -s dotglob
mv req_is_life/* .
```

### Customization of the Docker stack

The template has a fairly simple stack setup via Docker. But there are some
commented lines that can be easily commented in to install f.e. the dependencies
on container start as well as spawning a `phx.server` via the
`docker/app/run.sh` script and/or add a database via the `docker-compose.yml`.

#### Renaming containers

You might want to adapt the naming of the Docker stack containers like use something
more meaningful than f.e. `app` for the application container. Please check
and replace occurrences in the following file:

- Change `compose.yml`
- Adapt `justfile`

## License

MIT
