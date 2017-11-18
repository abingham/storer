#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly PARM=${1:-test}

. ${ROOT_DIR}/env.${PARM}
. ${ROOT_DIR}/env.port

docker-compose \
  --file ${ROOT_DIR}/docker-compose.yml \
  --file ${ROOT_DIR}/docker-compose.${PARM}.yml \
    down
