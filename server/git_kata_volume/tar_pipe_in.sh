#!/bin/bash
set -e

# called from pipe_build_up_test.sh

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly PARM=${1:-test}

. ${MY_DIR}/../../env.${PARM}

cat ${MY_DIR}/5A0F824303.tgz \
    | docker exec \
       --interactive \
         storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"
