#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly PARM=${1:-test}

. ${ROOT_DIR}/env.${PARM}
. ${ROOT_DIR}/env.port

check_up()
{
  if ! docker ps --filter status=running --format '{{.Names}}' | grep ^${1}$ ; then
    echo
    echo "${1} not up"
    docker logs ${1}
    exit 1
  fi
}

docker-compose \
  --file ${ROOT_DIR}/docker-compose.yml \
  --file ${ROOT_DIR}/docker-compose.${PARM}.yml \
    up -d

# crude wait for services
sleep 5
check_up 'storer_server'
check_up 'storer_client'
