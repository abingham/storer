#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

source "${ROOT_DIR}/env.test"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  --file "${ROOT_DIR}/docker-compose.test.yml" \
  down \
  --remove-orphans \
  --volumes
