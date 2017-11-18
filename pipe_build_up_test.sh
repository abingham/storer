#!/bin/bash
set -e

readonly PARM=test
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/env.${PARM}
. ${MY_DIR}/env.port

${MY_DIR}/server/git_kata_volume/build_data_container.sh ${PARM}
${MY_DIR}/sh/build_docker_images.sh ${PARM}
${MY_DIR}/sh/docker_containers_up.sh ${PARM}
${MY_DIR}/server/git_kata_volume/tar_pipe_in.sh ${PARM}
${MY_DIR}/sh/run_tests_in_containers.sh ${*}
${MY_DIR}/sh/docker_containers_down.sh ${PARM}
