#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

export SHA=$(cd "${MY_DIR}" && git rev-parse HEAD)

. "${ROOT_DIR}/env.test"
. "${ROOT_DIR}/env.common"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  --file "${ROOT_DIR}/docker-compose.test.yml" \
    build
