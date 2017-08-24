#!/bin/bash
set -e

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

${ROOT_DIR}/server/git_kata/build.sh
${ROOT_DIR}/server/git_kata/fill.sh

docker-compose --file ${ROOT_DIR}/docker-compose.yml build
