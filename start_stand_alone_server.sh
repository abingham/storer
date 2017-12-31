#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/env.prod
. ${MY_DIR}/env.port

${MY_DIR}/server/katas_volume/build_data_container.sh

docker-compose \
  --file ${MY_DIR}/docker-compose.yml \
  --file ${MY_DIR}/docker-compose.prod.yml \
  up -d

echo "Don't forget to open port ${CYBER_DOJO_STORER_SERVER_PORT}"