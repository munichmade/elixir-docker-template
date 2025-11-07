# justfile for Elixir Docker Template

[private]
default: help

app_name := "my_app"
docker_compose_file := "compose.yml"

[doc("Start the stack")]
[group("stack")]
start:
  @docker compose -f {{docker_compose_file}} up -d

[doc("Stop the stack")]
[group("stack")]
stop:
  @docker compose -f {{docker_compose_file}} down

[doc("Rebuild the images")]
[group("stack")]
rebuild args:
  @docker compose build {{args}}

[doc("Clean build artifacts and dependencies")]
[group("stack")]
[confirm("This will remove all dependencies. Continue?")]
clean:
  @docker compose -f {{docker_compose_file}} down -v --remove-orphans

[doc("Reset the stack (stop and remove containers, volumes, etc.)")]
[group("stack")]
[confirm("This will remove all containers, images, volumes! Continue?")]
reset:
  @docker compose -f {{docker_compose_file}} down -v --remove-orphans

[doc("Run IEx session")]
[group("dev")]
iex:
  @docker compose -f {{docker_compose_file}} exec app iex

[doc("Run tests")]
[group("dev")]
test:
  @docker compose -f {{docker_compose_file}} exec app mix test

[doc("Run migrations")]
[group("dev")]
migrate:
  @docker compose -f {{docker_compose_file}} exec app mix ecto.migrate

[doc("Run Phoenix server")]
[group("dev")]
console:
  @docker compose -f {{docker_compose_file}} exec app iex -S mix phx.server

[doc("Create a new Mix project")]
[group("one-time")]
create: start
  @just installer-input
  @docker compose -f {{docker_compose_file}} cp input.sh app:/tmp/input.sh
  @docker compose -f {{docker_compose_file}} exec app chmod +x /tmp/input.sh
  @docker compose -f {{docker_compose_file}} exec app bash -c "/tmp/input.sh"
  @rm input.sh

[private]
installer-input:
  #!/usr/bin/env bash
  echo "You can paste your installer command next."
  TMPFILE="input.sh"
  ${EDITOR:-vim} "$TMPFILE"

[doc("List available recipes")]
help:
  @just --list

