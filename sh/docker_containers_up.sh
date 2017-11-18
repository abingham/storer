#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

check_up()
{
  if ! docker ps --filter status=running --format '{{.Names}}' | grep ^${1}$ ; then
    echo
    echo "${1} not up"
    docker logs ${1}
    exit 1
  fi
}

. ${ROOT_DIR}/env.test

docker-compose \
  --file ${ROOT_DIR}/docker-compose.yml \
  --file ${ROOT_DIR}/docker-compose.test.yml \
    up -d

# crude wait for services
sleep 5
check_up 'storer_server'
check_up 'storer_client'
