#!/bin/bash

# script to copy 1/256th of the katas held in storer.
# pass in the 2-digit dir eg, 00 58 EF etc.
# This gives you a file such as 1F.tgz
# Untar this to give 1F/00C1BFC8/...
# You can then use tar_1_kata.sh to make this into a
# single tgz file ready for stubbing in the tests.

CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
VOLUME_PATH=/usr/src/cyber-dojo/katas
IMAGE_NAME=alpine:latest

docker run --rm \
  --volumes-from ${CONTAINER_NAME}:ro \
  --volume $(pwd):/backup:rw \
  ${IMAGE_NAME} \
  tar -zcf /backup/$1.tgz -C ${VOLUME_PATH} $1