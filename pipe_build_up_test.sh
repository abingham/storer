#!/bin/bash
set -e

readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

${MY_DIR}/sh/build_docker_images.sh
${MY_DIR}/server/git_kata_volume/build_data_container.sh
${MY_DIR}/sh/docker_containers_up.sh
${MY_DIR}/server/git_kata_volume/tar_pipe_in.sh
${MY_DIR}/sh/run_tests_in_containers.sh ${*}
