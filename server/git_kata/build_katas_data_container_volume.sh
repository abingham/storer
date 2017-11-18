#!/bin/bash
set -e

# called from pipe_build_up_test.sh

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly CONTEXT_DIR=${MY_DIR}
readonly TAG=cyberdojo/git_kata

. ${MY_DIR}/../../.env

# TODO: only remove it if its there
(docker rm --force --volumes ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER}) || true

docker build \
  --build-arg=CYBER_DOJO_GIT_KATA_ROOT=${CYBER_DOJO_KATAS_ROOT} \
  --tag=${TAG} \
  --file=${MY_DIR}/Dockerfile \
  ${CONTEXT_DIR}

docker create \
  --name ${CYBER_DOJO_GIT_KATA_DATA_CONTAINER} \
  ${TAG} \
  echo 'cdfGitKataDC' > /dev/null

