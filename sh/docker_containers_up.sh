#!/bin/bash

wait_until_ready()
{
  local name="${1}"
  local port="${2}"
  local max_tries=20
  local cmd="curl --silent --fail --data '{}' -X GET http://localhost:${port}/sha"
  cmd+=" > /dev/null 2>&1"

  if [ ! -z ${DOCKER_MACHINE_NAME} ]; then
    cmd="docker-machine ssh ${DOCKER_MACHINE_NAME} ${cmd}"
  fi
  echo -n "Waiting until ${name} is ready"
  for _ in $(seq ${max_tries})
  do
    echo -n '.'
    if eval ${cmd} ; then
      echo 'OK'
      return
    else
      sleep 0.1
    fi
  done
  echo 'FAIL'
  echo "${name} not ready after ${max_tries} tries"
  docker logs ${name}
  exit 1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

wait_till_up()
{
  local name="${1}"
  local n=10
  while [ $(( n -= 1 )) -ge 0 ]
  do
    if docker ps --filter status=running --format '{{.Names}}' | grep -q "^${name}$" ; then
      return
    else
      sleep 0.5
    fi
  done
  echo "${name} not up after 5 seconds"
  docker logs "${name}"
  exit 1
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

exit_unless_clean()
{
  local name="${1}"
  local docker_logs=$(docker logs "${name}")
  echo -n "Checking ${name} started cleanly..."
  if [[ -z "${docker_logs}" ]]; then
    echo 'OK'
  else
    echo 'FAIL'
    echo "[docker logs] not empty on startup"
    echo "<docker_log>"
    echo "${docker_logs}"
    echo "</docker_log>"
    exit 1
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - -

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

source "${ROOT_DIR}/env.test"

docker-compose \
  --file "${ROOT_DIR}/docker-compose.yml" \
  --file "${ROOT_DIR}/docker-compose.test.yml" \
  up \
  -d \
  --force-recreate

wait_until_ready  'test-storer-server' 4577
exit_unless_clean 'test-storer-server'

wait_till_up 'test-storer-client'
wait_till_up 'test-storer-starter-server'
