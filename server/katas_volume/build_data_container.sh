#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly PARAM=${1:-prod}

. ${MY_DIR}/../../env.${PARAM}

one_time_creation_of_katas_data_container()
{
  if ! docker ps --all | grep -s ^${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}$ > /dev/null ; then
    local readonly TAG=cyberdojo/tag
    docker build \
        --build-arg=CYBER_DOJO_KATAS_ROOT=${CYBER_DOJO_KATAS_ROOT} \
        --tag=${TAG} \
        --file=${MY_DIR}/Dockerfile \
        ${MY_DIR}

    docker create \
        --name ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} \
        ${TAG} \
        echo 'cdfKatasDC'
    echo "${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} created"
  else
    echo "${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} already present"
  fi
}

one_time_creation_of_katas_data_container
