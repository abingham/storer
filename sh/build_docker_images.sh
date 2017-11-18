#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

${ROOT_DIR}/server/git_kata/build_katas_data_container_volume.sh

docker-compose --file ${ROOT_DIR}/docker-compose.yml build
