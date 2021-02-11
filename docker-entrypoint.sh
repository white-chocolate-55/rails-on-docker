#!/bin/bash

set -eu

bundle check || true

yarn check --integrity --silent || true

if [ "${1:-}" = rails -a "${2}:-" = server ]; then
  if [ -f tmp/pids/server.pid ]; then
    rm -v tmp/pids/server.pid
  fi
fi

exec "$@"
