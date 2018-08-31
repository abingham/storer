#!/bin/bash

# script to copy one kata held in storer.
# pass in the 10-digit id in its 2 parts.

readonly CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
readonly VOLUME_PATH=/usr/src/cyber-dojo/katas
readonly OUTER=$1  # eg 5A
readonly INNER=$2  # eg 0F824303

docker run --rm \
  --volumes-from ${CONTAINER_NAME}:ro \
  --volume $(pwd):/backup:rw \
  alpine:latest \
  tar -zcf /backup/backup_${OUTER}${INNER}.tgz \
    -C ${VOLUME_PATH}/${OUTER} ${INNER}



