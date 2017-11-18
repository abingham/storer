#!/bin/bash
set -e

one_time_creation_of_katas_data_container()
{
  local readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
  local readonly CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER

  if ! docker ps --all | grep -s ${CONTAINER_NAME} > /dev/null ; then
    local readonly TAG=cyberdojo/tag
    docker build \
        --build-arg=CYBER_DOJO_KATAS_ROOT=/usr/src/cyber-dojo/katas \
        --tag=${TAG} \
        --file=${MY_DIR}/Dockerfile \
        ${MY_DIR}

    docker create \
        --name ${CONTAINER_NAME} \
        ${TAG} \
        echo 'cdfKatasDC'
    echo "${CONTAINER_NAME} created"
  else
    echo "${CONTAINER_NAME} already present"
  fi
}

one_time_creation_of_katas_data_container
