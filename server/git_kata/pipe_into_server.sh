#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

# TODO: this need to come from top-level .env file
CYBER_DOJO_KATAS_ROOT=/usr/src/cyber-dojo/katas

cd ${MY_DIR} && \
  tar -zcf - 5A \
    | docker exec \
       --interactive \
         storer_server \
           sh -c 'tar -zxf - -C /usr/src/cyber-dojo/katas'
