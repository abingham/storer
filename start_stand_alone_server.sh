#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
readonly PARM=prod

. ${MY_DIR}/env.${PARM}
. ${MY_DIR}/env.port

${MY_DIR}/server/katas_volume/build_data_container.sh ${PARM}
${MY_DIR}/sh/build_docker_images.sh ${PARM}
${MY_DIR}/sh/docker_containers_up.sh ${PARM}
