#!/bin/bash
set -e
set -x

MY_DIR="$( cd "$( dirname "${0}" )" && pwd )"
CYBER_DOJO_GITTED_KATAS_ROOT=/tmp/katas
CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER=cyber-dojo-gitted-katas-DATA-CONTAINER

cd ${MY_DIR}
tar -xvf 5A0F824303.tgz

docker cp \
  ${MY_DIR}/5A \
  ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER}:${CYBER_DOJO_GITTED_KATAS_ROOT}/5A

echo 4
ls -al ${MY_DIR}/5A
echo 5
ls -al ${MY_DIR}/5A/0F824303/spider
rm -rf 5A

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"

# can't exec directly into container as it is not running

docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "chown -R cyber-dojo:cyber-dojo /tmp/katas"

echo 6
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas && ls -al"

echo 7
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider && ls -al"

echo 8
docker run \
  --rm \
  --tty \
  --volumes-from ${CYBER_DOJO_GITTED_KATAS_DATA_CONTAINER} \
  cyberdojo/ruby:latest \
  sh -c "cd /tmp/katas/5A/0F824303/spider/.git && ls -al"

