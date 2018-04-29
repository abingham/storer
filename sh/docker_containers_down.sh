#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

. "${ROOT_DIR}/env.test"
. "${ROOT_DIR}/env.common"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  --file "${ROOT_DIR}/docker-compose.test.yml" \
  down \
  --remove-orphans \
  --volumes
