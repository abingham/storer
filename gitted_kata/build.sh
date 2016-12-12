#!/bin/bash
set -e

echo 0
docker volume ls

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CONTEXT_DIR=${MY_DIR}
TAG=cyberdojo/gitted_katas
CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

(docker rm --force --volumes ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER}) || true

echo 1
docker volume ls

cd ${MY_DIR}

docker build \
  --build-arg=CYBER_DOJO_GITTED_KATAS_ROOT=/tmp/katas \
  --tag=${TAG} \
  --file=Dockerfile \
  ${CONTEXT_DIR}

echo 2
docker volume ls

CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

docker create \
  --name ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  ${TAG} \
  echo 'cdfGittedKatasDC' > /dev/null

echo 3
docker volume ls

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"
