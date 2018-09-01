#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

source ${MY_DIR}/env.prod

# ${MY_DIR}/katas_volume/build_data_container.sh

docker-compose \
  --file ${MY_DIR}/docker-compose.yml \
  --file ${MY_DIR}/docker-compose.prod.yml \
  up -d

echo "Don't forget to open port ${STORER_SERVICE_PORT}"