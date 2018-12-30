#!/bin/bash
set -e

# cyberdojo/inserter image is created in https://github.com/cyber-dojo/inserter

readonly STORER_CONTAINER=test-storer-server

echo -n "Inserting test-data into ${STORER_CONTAINER}"

docker run \
   --rm -it \
   --volume /var/run/docker.sock:/var/run/docker.sock \
   cyberdojo/inserter \
     ${STORER_CONTAINER} \
      old red rm_fail
