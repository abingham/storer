#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly PARAM=test

. ${ROOT_DIR}/env.${PARAM}
. ${ROOT_DIR}/env.port

docker-compose \
  --file ${ROOT_DIR}/docker-compose.yml \
  --file ${ROOT_DIR}/docker-compose.${PARAM}.yml \
  down \
  --remove-orphans \
  --volumes
