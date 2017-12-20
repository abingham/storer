#!/bin/bash
set -e

readonly PARAM=test
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/env.${PARAM}
. ${MY_DIR}/env.port

${MY_DIR}/server/katas_volume/build_data_container.sh ${PARAM}
${MY_DIR}/sh/build_docker_images.sh ${PARAM}
${MY_DIR}/sh/docker_containers_up.sh ${PARAM}
${MY_DIR}/server/kata_old_git/tar_pipe_in.sh ${PARAM}
${MY_DIR}/server/katas_old/tar_pipe_in.sh ${PARAM}
${MY_DIR}/sh/run_tests_in_containers.sh ${*}
${MY_DIR}/sh/docker_containers_down.sh ${PARAM}
