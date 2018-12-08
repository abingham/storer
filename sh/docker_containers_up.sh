#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

source "${ROOT_DIR}/env.test"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  --file "${ROOT_DIR}/docker-compose.test.yml" \
  up \
  -d \
  --force-recreate

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wait_till_up()
{
  local n=10
  while [ $(( n -= 1 )) -ge 0 ]
  do
    if docker ps --filter status=running --format '{{.Names}}' | grep -q "^${1}$" ; then
      return
    else
      sleep 0.5
    fi
  done
  echo "${1} not up after 5 seconds"
  docker logs "${1}"
  exit 1
}

wait_till_up 'test-storer-server'
wait_till_up 'test-storer-client'
wait_till_up 'test-storer-starter-server'

# There is a bug somewhere. The following command gives
# `/home/storer` is not a directory.
#
# docker logs test-storer-server
