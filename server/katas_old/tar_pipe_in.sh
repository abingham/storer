#!/bin/bash
set -e

# called from pipe_build_up_test.sh

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly PARAM=${1:-test}

. ${MY_DIR}/../../env.${PARAM}

cat ${MY_DIR}/420B05BA0A.tgz \
  | docker run \
      --rm \
      --interactive \
      --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}:rw \
      alpine:latest \
        sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/420F2A2979.tgz \
    | docker run \
       --rm \
       --interactive \
       --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}:rw \
       alpine:latest \
         sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/421F303E80.tgz \
    | docker run \
       --rm \
       --interactive \
       --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}:rw \
       alpine:latest \
         sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/420BD5D5BE.tgz \
    | docker run \
       --rm \
       --interactive \
       --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}:rw \
       alpine:latest \
         sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/421AFD7EC5.tgz \
    | docker run \
       --rm \
       --interactive \
       --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME}:rw \
       alpine:latest \
         sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"
