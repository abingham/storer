#!/bin/bash
set -e
set -x

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CYBER_DOJO_GITTED_KATAS_ROOT=/tmp/katas
CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

ls -al ${MY_DIR}/5A
ls -al ${MY_DIR}/5A/0F824303/spider

docker cp \
  ${MY_DIR}/5A \
  ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER}:${CYBER_DOJO_GITTED_KATAS_ROOT}/5A

echo 4
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"

echo 5
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"

echo 6
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cat /etc/passwd"

# can't exec directly into container as it is not running

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "chown -R cyber-dojo:cyber-dojo /tmp/katas"

# This seems to have worked. 5A is now owned by cyber-dojo
echo 7
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"

# This shows nothing. It seems the .git dir is not there
echo 8
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider && ls -al"

echo 9
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider/.git && ls -al"

