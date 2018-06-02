
The test data
=============

This dir holds six examples of katas used as data for storer tests.
They are tar-piped into storer.
They are used to test methods which rely on
  o) handling of old style avatar .git dirs
  o) using starter.old_manifest(language) to convert from the
     old-style manifest.json format to the new-style manifest.json
     format. See below.


There are four katas with the old-style .git dirs:
---------------------------------------------------------------
id           avatar       lights     language         renaming?
---------------------------------------------------------------
5A/0F824303  spider       8          Python-behave    no
42/0BD5D5BE  hummingbird  0          Python-py.test   no
42/1AFD7EC5  wolf         1          Ruby-Rspec       yes Ruby-RSpec
42/1F303E80  buffalo      36         C                yes 'C (gcc)-assert'

There are two katas with the new style (no .git dirs)
---------------------------------------------------------------
id           avatar       lights     language         renaming?
---------------------------------------------------------------
42/0B05BA0A  dolphin      20         Java-JUnit       no
42/0F2A2979  snake        0          PHP-PHPUnit      no



How I got the test data
=======================
I got all the katas with an outer-id of 42 from the running server
using scripts/get256.sh
This file is katas_42.tgz on the converter repo.
I untarred this to 42/... dirs
  $ cd cyberdojo/storer
  $ tar -xf katas_42.tgz
I then extracted the five 42/... katas as follows
  $ tar_1_kata.sh 42 0BD5D5BE
  $ tar_1_kata.sh 42 1AFD7EC5
  $ tar_1_kata.sh 42 1F303E80
  $ tar_1_kata.sh 42 0B05BA0A
  $ tar_1_kata.sh 42 0F2A2979


Alternatively you could get katas out of a running cyber-dojo server
using something like this:

   CONTAINER_NAME=cyber-dojo-katas-DATA-CONTAINER
   VOLUME_PATH=/usr/src/cyber-dojo/katas
   OUTER=5A
   INNER=0F824303
   docker run --rm \
     --volumes-from ${CONTAINER_NAME}:ro \
     --volume $(pwd):/backup:rw \
     alpine:latest \
     tar -zcf /backup/backup_5A0F824303.tgz -C ${VOLUME_PATH}/5A 0F824303



