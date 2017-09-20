#!/bin/bash

readonly ROOT_DIR="$( cd "$( dirname "${0}" )" && cd .. && pwd )"

docker-compose --file ${ROOT_DIR}/docker-compose.yml down
docker rm -v cyber-dojo-git-kata-DATA-CONTAINER
