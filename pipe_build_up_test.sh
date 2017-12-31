#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/env.test
. ${MY_DIR}/env.port

${MY_DIR}/sh/docker_containers_down.sh
${MY_DIR}/sh/build_docker_images.sh
${MY_DIR}/sh/docker_containers_up.sh
${MY_DIR}/server/test/katas_old/tar_pipe_in.sh
${MY_DIR}/sh/run_tests_in_containers.sh ${*}
if [ $? -eq 0 ]; then
  ${MY_DIR}/sh/docker_containers_down.sh
fi
