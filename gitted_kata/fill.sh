#!/bin/bash
set -e
set -x

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CYBER_DOJO_GITTED_KATAS_ROOT=/tmp/katas
CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

ls -al ${MY_DIR}/5A

docker cp \
  ${MY_DIR}/5A/. \
  ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER}:${CYBER_DOJO_GITTED_KATAS_ROOT}/5A


echo 4
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider && ls -al"

# can't exec directly into container as it is not running

docker pull cyberdojo/ruby:latest

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "chown -R cyber-dojo /tmp/katas"

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider && ls -al"

