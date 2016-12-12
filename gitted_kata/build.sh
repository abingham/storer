#!/bin/bash
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CONTEXT_DIR=${MY_DIR}
TAG=cyberdojo/gitted_katas
CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

docker rm -f ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} || true

cd ${MY_DIR}

docker build \
          --build-arg=CYBER_DOJO_GITTED_KATAS_ROOT=/tmp/katas \
          --tag=${TAG} \
          --file=Dockerfile \
          ${CONTEXT_DIR}

CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

docker create \
          --name ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
          ${TAG} \
          echo 'cdfGittedKatasDC' > /dev/null
