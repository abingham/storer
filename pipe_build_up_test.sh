#!/bin/bash
set -e

readonly PARAM=test
readonly MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"

. ${MY_DIR}/env.${PARAM}
. ${MY_DIR}/env.port

${MY_DIR}/server/katas_volume/build_data_container.sh ${PARAM}
${MY_DIR}/server/katas_old/tar_pipe_in.sh ${PARAM}
${MY_DIR}/sh/build_docker_images.sh ${PARAM}

#docker run --rm -it \
#  --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} \
#    cyberdojo/storer \
#    sh -c "cd /tmp/katas && chown -R cyber-dojo:cyber-dojo *"

#docker run --rm -it \
#  --volumes-from ${CYBER_DOJO_KATA_DATA_CONTAINER_NAME} \
#    cyberdojo/storer \
#    sh -c "cd /tmp/katas && ls -al"

${MY_DIR}/sh/docker_containers_up.sh ${PARAM}
${MY_DIR}/sh/run_tests_in_containers.sh ${*}
${MY_DIR}/sh/docker_containers_down.sh ${PARAM}
