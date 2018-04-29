#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

export SHA=$(cd "${MY_DIR}" && git rev-parse HEAD)

. "${MY_DIR}/env.test"
. "${MY_DIR}/env.common"

"${MY_DIR}/sh/docker_containers_down.sh"
"${MY_DIR}/sh/build_docker_images.sh"
"${MY_DIR}/sh/docker_containers_up.sh"
"${MY_DIR}/katas_old/tar_pipe_in.sh"
if "${MY_DIR}/sh/run_tests_in_containers.sh" "$@"; then
  "${MY_DIR}/sh/docker_containers_down.sh"
fi
