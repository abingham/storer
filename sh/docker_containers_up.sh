#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"
readonly PARM=${1:-test}

. ${ROOT_DIR}/env.${PARM}
. ${ROOT_DIR}/env.port

wait_till_up()
{
  local n=10
  while [ $(( n -= 1 )) -ge 0 ]
  do
    if docker ps --filter status=running --format '{{.Names}}' | grep ^${1}$ ; then
      return
    else
      sleep 0.5
    fi
  done
  echo "${1} not up after 5 seconds"
  docker logs ${1}
  exit 1
}

docker-compose \
  --file ${ROOT_DIR}/docker-compose.yml \
  --file ${ROOT_DIR}/docker-compose.${PARM}.yml \
    up -d

wait_till_up 'storer_server'
wait_till_up 'storer_client'
