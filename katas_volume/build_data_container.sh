#!/bin/bash
set -e

# called from start_stand_alone_server.sh

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly CONTEXT_DIR=${MY_DIR}
readonly TAG=cyberdojo/storer_kata

source ${MY_DIR}/../env.prod

docker rm \
  --force \
  --volumes \
    ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} || true

docker build \
  --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
  --tag=${TAG} \
  --file=${MY_DIR}/Dockerfile \
  ${CONTEXT_DIR}

docker create \
  --name ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} \
  ${TAG} \
  echo 'cdfKatasDC' > /dev/null

