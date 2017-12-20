#!/bin/bash
set -e

# called from pipe_build_up_test.sh

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly PARAM=${1:-test}

. ${MY_DIR}/../../env.${PARAM}

cat ${MY_DIR}/420B05BA0A.tgz \
    | docker exec \
       --interactive \
         test_storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/420F2A2979.tgz \
    | docker exec \
       --interactive \
         test_storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/421F303E80.tgz \
    | docker exec \
       --interactive \
         test_storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/420BD5D5BE.tgz \
    | docker exec \
       --interactive \
         test_storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"

cat ${MY_DIR}/421AFD7EC5.tgz \
    | docker exec \
       --interactive \
         test_storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"
