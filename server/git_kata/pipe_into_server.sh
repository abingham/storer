#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/../../.env

cd ${MY_DIR} && \
  tar -zcf - 5A \
    | docker exec \
       --interactive \
         storer_server \
           sh -c "tar -zxf - -C ${CYBER_DOJO_KATAS_ROOT}"
