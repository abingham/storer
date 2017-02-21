#!/bin/bash
set -e

# called from pipe_build_up_test.sh

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CONTEXT_DIR=${MY_DIR}
TAG=cyberdojo/git_kata
CYBER_DOJO_GIT_KATA_DATA_CONTAINER=cyber-dojo-git-kata-DATA-CONTAINER

(docker rm --force --volumes ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER}) || true

cd ${MY_DIR}

docker build \
  --build-arg=CYBER_DOJO_GIT_KATA_ROOT=/tmp/katas \
  --tag=${TAG} \
  --file=Dockerfile \
  ${CONTEXT_DIR}

docker create \
  --name ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER} \
  ${TAG} \
  echo 'cdfGitKataDC' > /dev/null
