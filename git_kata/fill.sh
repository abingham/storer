#!/bin/bash
set -e

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CYBER_DOJO_GIT_KATA_ROOT=/tmp/katas
CYBER_DOJO_GIT_KATA_DATA_CONTAINER=cyber-dojo-git-kata-DATA-CONTAINER

cd ${MY_DIR}
tar -xf 5A0F824303.tgz
docker cp \
  ${MY_DIR}/5A \
  ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER}:${CYBER_DOJO_GIT_KATA_ROOT}/5A
rm -rf 5A

# can't exec directly into git-kata-data-container as it is not running

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "chown -R cyber-dojo:cyber-dojo /tmp/katas"
