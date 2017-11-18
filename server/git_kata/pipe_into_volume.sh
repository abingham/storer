#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/../../.env

cat ${MY_DIR}/5A0F824303.tgz \
    | docker exec \
       --interactive \
         storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"
