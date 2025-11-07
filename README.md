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

## Prerequisites

You need to have the following installed:

- [Docker](https://docker.io) for running the code
- [Just](https://just.systems) for running commands

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
mix archive.install hex phx_new 1.8.1 --force

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
