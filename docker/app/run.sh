#!/usr/bin/env bash

export ERL_AFLAGS="-kernel shell_history enabled -kernel shell_history_file_bytes 1024000"

mix deps.get

iex
