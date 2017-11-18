#!/bin/bash
set -e

# verify that the cyber-dojo user can run docker-commands
# Fails on Travis
# docker ps -a

# The --host is needed for IPv4 and IPv6 addresses
bundle exec rackup \
  --warn \
  --host 0.0.0.0 \
  --port ${PORT} \
  --server thin \
  --env production \
    config.ru
