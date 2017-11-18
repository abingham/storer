#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

check_up()
{
  set +e
  local s=$(docker ps --filter status=running --format '{{.Names}}' | grep ^${1}$)
  set -e
  if [ "${s}" != "${1}" ]; then
    echo
    echo "${1} not up"
    docker logs ${1}
    exit 1
  fi
}

docker-compose --file ${ROOT_DIR}/docker-compose.yml up -d

# crude wait for services
sleep 2
check_up 'storer_server'
check_up 'storer_client'
